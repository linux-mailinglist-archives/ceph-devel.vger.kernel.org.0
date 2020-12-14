Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119702D9D9D
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Dec 2020 18:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440367AbgLNR0n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Dec 2020 12:26:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:42782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439009AbgLNR0a (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Dec 2020 12:26:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AEDB2AC10;
        Mon, 14 Dec 2020 17:25:49 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 18136ba1;
        Mon, 14 Dec 2020 17:26:18 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: wip-msgr2
References: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
        <87wnxk1iwy.fsf@suse.de>
        <CAOi1vP-U4Hdw=zYNFmhX_TJeuUiAAXMwvAUJLmG++F8mN+z5HQ@mail.gmail.com>
Date:   Mon, 14 Dec 2020 17:26:18 +0000
In-Reply-To: <CAOi1vP-U4Hdw=zYNFmhX_TJeuUiAAXMwvAUJLmG++F8mN+z5HQ@mail.gmail.com>
        (Ilya Dryomov's message of "Mon, 14 Dec 2020 17:59:43 +0100")
Message-ID: <87sg881epx.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ilya Dryomov <idryomov@gmail.com> writes:

> On Mon, Dec 14, 2020 at 4:55 PM Luis Henriques <lhenriques@suse.de> wrote:
>>
>> Ilya Dryomov <idryomov@gmail.com> writes:
>>
>> > Hello,
>> >
>> > I've pushed wip-msgr2 and opened a dummy PR in ceph-client:
>> >
>> >   https://github.com/ceph/ceph-client/pull/22
>> >
>> > This set has been through a over a dozen krbd test suite runs with no
>> > issues other than those with the test suite itself.  The diffstat is
>> > rather big, so I didn't want to spam the list.  If someone wants it
>> > posted, let me know.  Any comments are welcome!
>>
>> That's *awesome*!  Thanks for sharing, Ilya.  Obviously this will need a
>> lot of time to digest but a quick attempt to do a mount using a v2 monitor
>> is just showing me a bunch of:
>>
>> libceph: mon0 (1)192.168.155.1:40898 socket closed (con state V1_BANNER)
>>
>> Note that this was just me giving it a try with a dummy vstart cluster
>> (octopus IIRC), so nothing that could be considered testing.  I'll try to
>> find out what I'm doing wrong in the next couple of days or, worst case,
>> after EOY vacations.
>
> Hi Luis,
>
> This is because the kernel continues to default to msgr1.  The socket
> gets closed by the mon right after it sees msgr1 banner and you should
> see "peer ... is using msgr V1 protocol" error in the log.
>
> For msgr2, you need to select a connection mode using the new ms_mode
> option:
>
>   ms_mode=legacy        - msgr1 (default)
>   ms_mode=crc           - crc mode, if denied fail
>   ms_mode=secure        - secure mode, if denied fail
>   ms_mode=prefer-crc    - crc mode, if denied agree to secure mode
>   ms_mode=prefer-secure - secure mode, if denied agree to crc mode

Ah, right.  I should have took a quick look at the patches first to check
for any new parameters.  Thanks for pointing me at that, I'll retry my
test using ms_mode.

Cheers,
-- 
Luis
