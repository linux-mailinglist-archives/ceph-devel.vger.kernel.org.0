Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0879F137672
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2020 19:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgAJSxl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jan 2020 13:53:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:34174 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728023AbgAJSxl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 13:53:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E4E9AACF2;
        Fri, 10 Jan 2020 18:53:38 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 10 Jan 2020 19:53:38 +0100
From:   Roman Penyaev <rpenyaev@suse.de>
To:     kefu chai <tchaikov@gmail.com>
Cc:     Radoslaw Zarzynski <rzarzyns@redhat.com>,
        Samuel Just <sjust@redhat.com>,
        The Esoteric Order of the Squid Cybernetic 
        <ceph-devel@vger.kernel.org>
Subject: Re: crimson-osd vs legacy-osd: should the perf difference be already
 noticeable?
In-Reply-To: <CAJE9aON93O75PPRjfuFGYrtpBxRHHuepGX+tEC3FkBSgM6TgNQ@mail.gmail.com>
References: <02e2209f66f18217aa45b8f7caf715f6@suse.de>
 <CAJE9aON93O75PPRjfuFGYrtpBxRHHuepGX+tEC3FkBSgM6TgNQ@mail.gmail.com>
Message-ID: <f3a976a6d2eba9cd8bd6bf46c0fc9967@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020-01-10 17:18, kefu chai wrote:

[skip]

>> 
>> First thing that catches my eye is that for small blocks there is no 
>> big
>> difference at all, but as the block increases, crimsons iops starts to
> 
> that's also our findings. and it's expected. as async messenger uses
> the same reactor model as seastar does. actually its original
> implementation was adapted from seastar's socket stream
> implementation.

Hm, regardless of model messenger should not be a bottleneck.  Take
a look on the results of fio_ceph_messenger load (runs pure messenger),
I can squeeze IOPS=89.8k, BW=351MiB/s on 4k block size, iodepth=32.
(also good example https://github.com/ceph/ceph/pull/26932 , almost
~200k)

With PG layer (memstore_debug_omit_block_device_write=true option)
I can reach 40k iops max.  Without PG layer (immediate completion
from the transport callback, osd_immediate_completions=true)
I get almost 60k.

Seems that here starts playing costs on client side and these costs
prevail.

> 
>> decline. Can it be the transport issue? Can be tested as well.
> 
> because seastar's socket facility reads from the wire with 4K chunk
> size, while classic OSD's async messenger reads the payload with the
> size suggested by the header. so when it comes to larger block size,
> it takes crimson-osd multiple syscalls and memcpy calls to read the
> request from wire, that's why classic OSD wins in this case.

Do you plan to fix that?

> have you tried to use multiple fio clients to saturate CPU capacity of
> OSD nodes?

Not yet.  But regarding CPU I have these numbers:

output of pidstat while rbd.fio is running, 4k block only:

legacy-osd

[roman@dell ~]$ pidstat 1 -p 109930
Linux 5.3.13-arch1-1 (dell)     01/09/2020      _x86_64_        (8 CPU)

03:51:49 PM   UID       PID    %usr %system  %guest   %wait    %CPU   
CPU  Command
03:51:51 PM  1000    109930   14.00    8.00    0.00    0.00   22.00     
1  ceph-osd
03:51:52 PM  1000    109930   40.00   19.00    0.00    0.00   59.00     
1  ceph-osd
03:51:53 PM  1000    109930   44.00   17.00    0.00    0.00   61.00     
1  ceph-osd
03:51:54 PM  1000    109930   40.00   20.00    0.00    0.00   60.00     
1  ceph-osd
03:51:55 PM  1000    109930   39.00   18.00    0.00    0.00   57.00     
1  ceph-osd
03:51:56 PM  1000    109930   41.00   20.00    0.00    0.00   61.00     
1  ceph-osd
03:51:57 PM  1000    109930   41.00   15.00    0.00    0.00   56.00     
1  ceph-osd
03:51:58 PM  1000    109930   42.00   16.00    0.00    0.00   58.00     
1  ceph-osd
03:51:59 PM  1000    109930   42.00   15.00    0.00    0.00   57.00     
1  ceph-osd
03:52:00 PM  1000    109930   43.00   15.00    0.00    0.00   58.00     
1  ceph-osd
03:52:01 PM  1000    109930   24.00   12.00    0.00    0.00   36.00     
1  ceph-osd


crimson-osd

[roman@dell ~]$ pidstat 1  -p 108141
Linux 5.3.13-arch1-1 (dell)     01/09/2020      _x86_64_        (8 CPU)

03:47:50 PM   UID       PID    %usr %system  %guest   %wait    %CPU   
CPU  Command
03:47:55 PM  1000    108141   67.00   11.00    0.00    0.00   78.00     
0  crimson-osd
03:47:56 PM  1000    108141   79.00   12.00    0.00    0.00   91.00     
0  crimson-osd
03:47:57 PM  1000    108141   81.00    9.00    0.00    0.00   90.00     
0  crimson-osd
03:47:58 PM  1000    108141   78.00   12.00    0.00    0.00   90.00     
0  crimson-osd
03:47:59 PM  1000    108141   78.00   12.00    0.00    1.00   90.00     
0  crimson-osd
03:48:00 PM  1000    108141   78.00   13.00    0.00    0.00   91.00     
0  crimson-osd
03:48:01 PM  1000    108141   79.00   13.00    0.00    0.00   92.00     
0  crimson-osd
03:48:02 PM  1000    108141   78.00   12.00    0.00    0.00   90.00     
0  crimson-osd
03:48:03 PM  1000    108141   77.00   11.00    0.00    0.00   88.00     
0  crimson-osd
03:48:04 PM  1000    108141   79.00   12.00    0.00    1.00   91.00     
0  crimson-osd


Seems quite saturated, almost twice more than legacy-osd.  Did you see 
something
similar?

--
Roman

