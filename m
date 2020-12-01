Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822632CAC18
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Dec 2020 20:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392388AbgLATY6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Dec 2020 14:24:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388004AbgLATY4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Dec 2020 14:24:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606850610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=hj6vI3nOqNvTIN7JQM//RrR1K/3lhIVW4FTGAPosDoA=;
        b=XAB55f5QR/TDI3liwRlj3edfSfP+/ArNzNcqnc6QjvvLtZVnPV/ME9HJbFcntorZT9lT0Y
        MLy5GrNDbNJa7olXgoPB36hjJd7S0e8r9kkVdQwGk/auhzghpt2uHH8dmttrIkxDiieT88
        i0ukKXPBaoYtocjZs2QvBIiMLxJLa6I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-JnE1zvXGPm66nTc3OlSNTg-1; Tue, 01 Dec 2020 14:23:26 -0500
X-MC-Unique: JnE1zvXGPm66nTc3OlSNTg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70CA1425C8;
        Tue,  1 Dec 2020 19:23:25 +0000 (UTC)
Received: from [10.10.114.245] (ovpn-114-245.rdu2.redhat.com [10.10.114.245])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 18FBB10013C1;
        Tue,  1 Dec 2020 19:23:24 +0000 (UTC)
Subject: Re: provisioning clients in teuthology with an extra local filesystem
To:     Jeff Layton <jlayton@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        sepia <sepia@ceph.io>
References: <36b421ea14b3b14226b3e7c0407876886bb74e08.camel@redhat.com>
 <ad5a9630-daa0-b379-c7f4-5a9a139cd3a5@redhat.com>
 <aa38cc3b2ed96fed0dbee443fed564ac8d1a151d.camel@redhat.com>
From:   David Galloway <dgallowa@redhat.com>
Autocrypt: addr=dgallowa@redhat.com; prefer-encrypt=mutual; keydata=
 xsBNBE60O2sBCADafZy0luRceto63vARvurZ7oepCBc+yBiDHHcFLmdZLs0nugjyYa1V1WW/
 j/tMPkjmQPGT1IcoXIrhppUXKrwXMkK4JB56GHI3cdximVuRMmHCY45ZbmAL7YnuNXz+5jbs
 iuzarsc9W3SyovQUx9n1lUymk1lASaPfNVdgzxl0/FHpKMhEqJGo0eQPh8o5M+ybZS9zXKNa
 QPiXJKLiHuise1hP4529ZTExjCqk+R3x6y7YwySKSFUhEVwY7ksU0rr/Xv5VVEsrLgS4nENe
 u9UQvJq2hp+RhgBH0ZV9+jLgwoYxjqbifJDlghbDPe7rhAfiD/xvoQFgAy/AOkVPRKHVABEB
 AAHNJERhdmlkIEdhbGxvd2F5IDxkZ2FsbG93YUByZWRoYXQuY29tPsLAdwQTAQgAIQUCVfr6
 SAIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRA4J2vQ1bgO+m5hB/kBOH7I2uhhhvGH
 BzGFKSh/1C9NO8ECg5N//b7xu9EtQfoVgNODTYqpG0mhH9phV7Cvld5gAlX3YV/m4lgDwJH9
 5fcNB2x7M6OEY2kOI20DxBKxVDmamhmQLQzm2ZFqbfHwh/H6zq3jdXWCbp8LQ9uvta5qbsFp
 rU4sVg2AhKAPrvr2JoO7MLVCdNfRhwdJFwvxlc6ltilateChU5dHpy2/2aSM3794VLZXQZkD
 Ei5PIc9XrXOKqqpbwMuizlh/tNA0O1a3jY8ccl9rYpCyELa9nfGw1HxXmfj8hMtndf077Bat
 7AxNyUoLu8+C9vD2F0oqXGumYCkcXIoSyiDAPY2IzsBNBE60O2sBCADlXsFRIss3rM3IW9dK
 8084c3kktyOyA0JO4cQtXglGVvmALIaqxLlQ8qabibmRgdozjh5YsYFIQwBasmD+0rZVEi7W
 OMc1pO/dbwAzlhzfmbAvkvzctB4CS2MP6RLkGR9MquiLAAWdfOiRoKeNkgSup8VlSPrvlXwF
 qsolEbH14LJGtJBF3uRUrhieyV+dQ5wE/UJCmuN/m1KWlZmcUeDbTefNM/NaWxSdycu27QyL
 PBMIS9bDHPoPAaPjRKoMr80aYbHLZxiXPXlP3wyfirWiN5jqL2mjcCqGqzAC2IPuWftD4oHr
 P+3w6cBi1noh1ps76iD37IUsU8tZgTX5sE8RABEBAAHCwF8EGAECAAkFAk60O2sCGwwACgkQ
 OCdr0NW4Dvq5ywf/ZEVxP1LOUnkab+B8ZDQs6L66bBMMuWaoUKp9ngdpSqKfSy6YnbmshKaE
 SkNBNlpVpdOweSBPnLx4ss2sksLwDxrQTxW71Zui67mUbdurhlkbsG1pM4c1sAcdqa7xG6nB
 +fkpwgn9bcvv3qQGuKDwit6fdIVnPRJckM1T8w8d0yG+0uNSzOhwKI6h8E0Za2ESLmTyfkr1
 FtSVF86xVAGMI8jMiccCzKfOlkP89ND84r5EDzeATa3Imv7xKCgcIlSuMQKk45506NFPQQlP
 nCTgp61XOM4EWjembxD6lWBXHltcm3K1dXvf3JbAxG7v2BSd0hRhnXfQdZoAzRJwYIHh2Q==
Message-ID: <0cdca09a-0c7d-66b6-f3d7-02b7a36410a2@redhat.com>
Date:   Tue, 1 Dec 2020 14:23:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <aa38cc3b2ed96fed0dbee443fed564ac8d1a151d.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 12/1/20 10:24 AM, Jeff Layton wrote:
> On Tue, 2020-12-01 at 10:22 -0500, David Galloway wrote:
>> On 12/1/20 9:55 AM, Jeff Layton wrote:
>>> I've been working on a patch series to overhaul the fscache code in the
>>> kclient. I also have this (really old) tracker to add fscache testing to
>>> teuthology:
>>>
>>>     https://tracker.ceph.com/issues/6373
>>>
>>> It would be ideal if the clients in such testing had a dedicated
>>> filesystem mounted on /var/cache/fscache, so that if it fills up it
>>> doesn't take down the rootfs with it. We'll also need to have
>>> cachefilesd installed and running in the client hosts.
>>>
>>> Is it possible to do this in teuthology? How would I approach this?
>>>
>>
>> I think I can make this happen pretty easily in ceph-cm-ansible.  What
>> I'd need from you is desired filesystem type and size.  Once I'm done
>> with my end, we'll need to create a cephlab.ansible overrides yaml
>> fragment to stick in that suite's qa directory.
>>
> 
> Ok, cool:
> 
> fstype: xfs or ext4 (either is fine)
> size: ~50g or so would be ideal, but we can probably get away with less 
>       if necessary
> 

Getting there...

https://github.com/ceph/ceph-cm-ansible/pull/592

Can you give me an optimal cachefilesd.conf and I'll set that up in
ceph-cm-ansible too?

