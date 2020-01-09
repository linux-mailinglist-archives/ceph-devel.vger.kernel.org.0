Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFEED135BBB
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 15:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731826AbgAIOwx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 09:52:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:34854 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730159AbgAIOwx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 09:52:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D51F2AD7B;
        Thu,  9 Jan 2020 14:52:49 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 09 Jan 2020 15:52:49 +0100
From:   Roman Penyaev <rpenyaev@suse.de>
To:     vitalif@yourcmc.ru
Cc:     ceph-devel@vger.kernel.org, ceph-devel-owner@vger.kernel.org
Subject: Re: crimson-osd vs legacy-osd: should the perf difference be already
 noticeable?
In-Reply-To: <34d373cf1e08ed8480655969d0be63a4@yourcmc.ru>
References: <02e2209f66f18217aa45b8f7caf715f6@suse.de>
 <34d373cf1e08ed8480655969d0be63a4@yourcmc.ru>
Message-ID: <a863f28906a908696de4a9ff10b3eb9a@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020-01-09 14:58, vitalif@yourcmc.ru wrote:
> I watched some of their crimson osd mettings on youtube and they
> discussed something similar...

Could you please share the link?

> however I thought they also said that
> crimson-osd eats less CPU cores during that test. Did it eat less CPU
> in your test?

Hm, I can't prove even that.  So here is the output of pidstat while
rbd.fio is running, 4k block only:


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

pidstat 1  -p 108141
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


--
Roman


