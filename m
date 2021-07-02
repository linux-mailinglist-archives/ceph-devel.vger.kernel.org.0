Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5952D3B99D9
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 02:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbhGBAEf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Jul 2021 20:04:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234063AbhGBAEf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 1 Jul 2021 20:04:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625184123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ctxclaA1IIijn5lMusGYGAB7aIrcKrn9MjdYoqtaNOs=;
        b=dP2IE+1biJ6+pv+leykUK7ILdkFg1vOybJ86xwuPft8XTGz76UNwNeS1Q/dT1HNU44rUN0
        wMrondMOgRaSLTG22905l6PGEC19XVgLFa+UBHSkxpaICl+QxlKbo2q7SCVUnhKtRmNul5
        Xo0vCa/SgjKTfHuKKX/YfirPJP+L02I=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-VL92ysTUMEq_1yESvl5jZQ-1; Thu, 01 Jul 2021 20:02:03 -0400
X-MC-Unique: VL92ysTUMEq_1yESvl5jZQ-1
Received: by mail-pg1-f200.google.com with SMTP id b17-20020a63a1110000b02902231e33459dso5182978pgf.17
        for <ceph-devel@vger.kernel.org>; Thu, 01 Jul 2021 17:02:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ctxclaA1IIijn5lMusGYGAB7aIrcKrn9MjdYoqtaNOs=;
        b=ufukD5gubE22gdsXoto/kA7CJB6RPQFeay5F0MAuLLO6vMhA0uazJYe4vIyiAFb/c9
         /H3NQVCBkND1G2GEUnaP9sr5a3LIPB4DAeBp+7vpcfpmOBvm7xDqjZKwVTUasETHGvLa
         aA23X5g9Q4vGIryQeLCzBWJwmuXiViPpx919KJOFRnm5LAcAWWyIk6EknEguOhCWH0B7
         zrpMJAKL3DeG6EvVNTr7RCCikV8M5VoUKA3WkQPNmqX1KU/vAgrEbxxsGP+/yMtTQGIW
         SZfAUFNmjAg3eIPtZA7JU4deL6jYJyiqk1KMWJE0VOzyKGjAJ5vwwrkdJ6qwxeHFRmJx
         um4A==
X-Gm-Message-State: AOAM532PeMqLGrv4Cmi94Yu5zXJEU1VG3Wo6902jNcAld/D01C8isPRI
        kSDRei4+qi5+R40Gy7tNTQOL6Vr7dEi4/U/R37oLoLuol148ziJXBrRmQDaqxNC6HA+E4rOgoeI
        nJhYIW4XnB6eOarV1WqHuKrmJ5cj9e/3f5jC31ZlPVxZBZJ3taOKH8Uo/el2gYyjQgem3ZEM=
X-Received: by 2002:a17:902:d213:b029:127:9520:7649 with SMTP id t19-20020a170902d213b029012795207649mr2095540ply.10.1625184121740;
        Thu, 01 Jul 2021 17:02:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyY7KukMCj1nA9lqh9FgQH0eVvPx6j4UwPjOWwZAAudREGLAx1AsWZmvudt7OuprIHbg0mMFQ==
X-Received: by 2002:a17:902:d213:b029:127:9520:7649 with SMTP id t19-20020a170902d213b029012795207649mr2095519ply.10.1625184121404;
        Thu, 01 Jul 2021 17:02:01 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u13sm1110390pga.64.2021.07.01.17.01.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 17:02:01 -0700 (PDT)
Subject: Re: [PATCH 4/5] ceph: flush the mdlog before waiting on unsafe reqs
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20210629044241.30359-1-xiubli@redhat.com>
 <20210629044241.30359-5-xiubli@redhat.com>
 <b531585184df099e633a4b92e3be23b4b8384253.camel@kernel.org>
 <4f2f6de6-eb1f-1527-de73-2378f262228b@redhat.com>
 <2e8aabad80e166d7c628fde9d820fc5f403e034f.camel@kernel.org>
 <379d5257-f182-c455-9675-b199aeb8ce1b@redhat.com>
 <CA+2bHPZNQU9wZr2W3FjW453KKFVi4q+LwVyicTPQ7kihhoQpQg@mail.gmail.com>
 <e917a3e1-2902-604b-5154-98086c95357f@redhat.com>
 <CA+2bHPY=xyqW48RfuGX8C9Br7vRUArF66AK5yDTOKH4Ewdt8dg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <afc7de2d-14fd-e01d-e31f-a8b30a0a66f1@redhat.com>
Date:   Fri, 2 Jul 2021 08:01:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CA+2bHPY=xyqW48RfuGX8C9Br7vRUArF66AK5yDTOKH4Ewdt8dg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/2/21 7:46 AM, Patrick Donnelly wrote:
> On Wed, Jun 30, 2021 at 11:18 PM Xiubo Li <xiubli@redhat.com> wrote:
>> And just now I have run by adding the time stamp:
>>
>>> fd = open("/path")
>>> fopenat(fd, "foo")
>>> renameat(fd, "foo", fd, "bar")
>>> fstat(fd)
>>> fsync(fd)
>> lxb ----- before renameat ---> Current time is Thu Jul  1 13:28:52 2021
>> lxb ----- after renameat ---> Current time is Thu Jul  1 13:28:52 2021
>> lxb ----- before fstat ---> Current time is Thu Jul  1 13:28:52 2021
>> lxb ----- after fstat ---> Current time is Thu Jul  1 13:28:52 2021
>> lxb ----- before fsync ---> Current time is Thu Jul  1 13:28:52 2021
>> lxb ----- after fsync ---> Current time is Thu Jul  1 13:28:56 2021
>>
>> We can see that even after 'fstat(fd)', the 'fsync(fd)' still will wait around 4s.
>>
>> Why your test worked it should be the MDS's tick thread and the 'fstat(fd)' were running almost simultaneously sometimes, I also could see the 'fsync(fd)' finished very fast sometimes:
>>
>> lxb ----- before renameat ---> Current time is Thu Jul  1 13:29:51 2021
>> lxb ----- after renameat ---> Current time is Thu Jul  1 13:29:51 2021
>> lxb ----- before fstat ---> Current time is Thu Jul  1 13:29:51 2021
>> lxb ----- after fstat ---> Current time is Thu Jul  1 13:29:51 2021
>> lxb ----- before fsync ---> Current time is Thu Jul  1 13:29:51 2021
>> lxb ----- after fsync ---> Current time is Thu Jul  1 13:29:51 2021
> Actually, I did a lot more testing on this. It's a unique behavior of
> the directory is /. You will see a getattr force a flush of the
> journal:
>
> 2021-07-01T23:42:18.095+0000 7fcc7741c700  7 mds.0.server
> dispatch_client_request client_request(client.4257:74 getattr
> pAsLsXsFs #0x1 2021-07-01T23:42:18.095884+0000 caller_uid=1147,
> caller_gid=1147{1000,1147,}) v5
> ...
> 2021-07-01T23:42:18.096+0000 7fcc7741c700 10 mds.0.locker nudge_log
> (ifile mix->sync w=2) on [inode 0x1 [...2,head] / auth v34 pv39 ap=6
> snaprealm=0x564734479600 DIRTYPARENT f(v0
> m2021-07-01T23:38:00.418466+0000 3=1+2) n(v6
> rc2021-07-01T23:38:15.692076+0000 b65536 7=2+5)/n(v0
> rc2021-07-01T19:31:40.924877+0000 1=0+1) (iauth sync r=1) (isnap sync
> r=4) (inest mix w=3) (ipolicy sync r=2) (ifile mix->sync w=2)
> (iversion lock w=3) caps={4257=pAsLsXs/-@32} | dirtyscattered=0
> request=1 lock=6 dirfrag=1 caps=1 dirtyparent=1 dirty=1 waiter=1
> authpin=1 0x56473913a580]
>
> You don't see that getattr for directories other than root. That's
> probably because the client has been issued more caps than what the
> MDS is willing to normally hand out for root.
>
> I'm not really sure why there is a difference. I even experimented
> with redundant getattr ("forced") calls to cause a journal flush on
> non-root directories but didn't get anywhere. Maybe you can
> investigate further? It'd be optimal if we could nudge the log just by
> doing a getattr.

Yeah, sure.

I will test more and try to figure out if we could do this by doing a 
getattr.

Thanks

BRs



>

