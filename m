Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F432CAE7A
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Dec 2020 22:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgLAVcg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Dec 2020 16:32:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35729 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729614AbgLAVcg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Dec 2020 16:32:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606858269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=Koh09aFoGL/jnrsKed3g4k0wTipK6EygVv742DoUVgk=;
        b=Y0EGu/xhi2c+DNXWv8Kwb+yP+FQOqTjlWJak//FJSLTlWAuuzpy2tJ5T6LD4dgFhODwwmX
        BJTJH33RxosxmN4kZKehQojl+yeNXb0JgrI32/tcayid1tj3UJPyyLW2koB0LVioYnU+NP
        85SDvYfPYOM3f8Ru5JHuTfJjBsYRANk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-daW0-EBPPTKyaErXk6-p7g-1; Tue, 01 Dec 2020 16:31:05 -0500
X-MC-Unique: daW0-EBPPTKyaErXk6-p7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3962B425C9;
        Tue,  1 Dec 2020 21:31:04 +0000 (UTC)
Received: from [10.10.114.245] (ovpn-114-245.rdu2.redhat.com [10.10.114.245])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B542860BFA;
        Tue,  1 Dec 2020 21:31:03 +0000 (UTC)
Subject: Re: provisioning clients in teuthology with an extra local filesystem
To:     Jeff Layton <jlayton@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        sepia <sepia@ceph.io>
References: <36b421ea14b3b14226b3e7c0407876886bb74e08.camel@redhat.com>
 <ad5a9630-daa0-b379-c7f4-5a9a139cd3a5@redhat.com>
 <aa38cc3b2ed96fed0dbee443fed564ac8d1a151d.camel@redhat.com>
 <0cdca09a-0c7d-66b6-f3d7-02b7a36410a2@redhat.com>
 <a4df6b959a978c5a6c76efce731a14a747e9fa49.camel@redhat.com>
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
Message-ID: <baea4c8b-7d5c-fc62-8a0a-fc2d77b2edf4@redhat.com>
Date:   Tue, 1 Dec 2020 16:31:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a4df6b959a978c5a6c76efce731a14a747e9fa49.camel@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------2F43AC79ECBA8D2455A52B38"
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------2F43AC79ECBA8D2455A52B38
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit


On 12/1/20 3:07 PM, Jeff Layton wrote:
> On Tue, 2020-12-01 at 14:23 -0500, David Galloway wrote:
>>
>> On 12/1/20 10:24 AM, Jeff Layton wrote:
>>> On Tue, 2020-12-01 at 10:22 -0500, David Galloway wrote:
>>>> On 12/1/20 9:55 AM, Jeff Layton wrote:
>>>>> I've been working on a patch series to overhaul the fscache code in the
>>>>> kclient. I also have this (really old) tracker to add fscache testing to
>>>>> teuthology:
>>>>>
>>>>>     https://tracker.ceph.com/issues/6373
>>>>>
>>>>> It would be ideal if the clients in such testing had a dedicated
>>>>> filesystem mounted on /var/cache/fscache, so that if it fills up it
>>>>> doesn't take down the rootfs with it. We'll also need to have
>>>>> cachefilesd installed and running in the client hosts.
>>>>>
>>>>> Is it possible to do this in teuthology? How would I approach this?
>>>>>
>>>>
>>>> I think I can make this happen pretty easily in ceph-cm-ansible.  What
>>>> I'd need from you is desired filesystem type and size.  Once I'm done
>>>> with my end, we'll need to create a cephlab.ansible overrides yaml
>>>> fragment to stick in that suite's qa directory.
>>>>
>>>
>>> Ok, cool:
>>>
>>> fstype: xfs or ext4 (either is fine)
>>> size: ~50g or so would be ideal, but we can probably get away with less 
>>>       if necessary
>>>
>>
>> Getting there...
>>
>> https://github.com/ceph/ceph-cm-ansible/pull/592
>>
>> Can you give me an optimal cachefilesd.conf and I'll set that up in
>> ceph-cm-ansible too?
>>
> 
> I never actually tweak the defaults in my local testing, so let's start
> with a default cachefilesd.conf as installed by the package. If we need
> to tweak it later, then we'll go from there.
> 

K.  I made it optional and used the package-provided defaults.

Your requested changes are implemented in ceph-cm-ansible.  I've
attached the yaml fragments you'll need to pass on the
`teuthology-suite` command line to set up the partition, filesystem, and
cachefilesd service.

e.g., teuthology-suite ... ~/fs-cache-smithi.yml

--------------2F43AC79ECBA8D2455A52B38
Content-Type: application/x-yaml;
 name="fscache-smithi.yml"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fscache-smithi.yml"

b3ZlcnJpZGVzOgogIGFuc2libGUuY2VwaGxhYjoKICAgIHNraXBfdGFnczogbHZtCiAgICB2
YXJzOgogICAgICB2YXJfbGliX3BhcnRpdGlvbjogIi9kZXYvbnZtZTBuMXA1IgogICAgICBj
b25maWd1cmVfY2FjaGVmaWxlc2Q6IHRydWUKICAgICAgZHJpdmVzX3RvX3BhcnRpdGlvbjoK
ICAgICAgICBudm1lMG4xOgogICAgICAgICAgZGV2aWNlOiAiL2Rldi9udm1lMG4xIgogICAg
ICAgICAgdW5pdDogIkdCIgogICAgICAgICAgc2l6ZXM6CiAgICAgICAgICAgIC0gIjAgODAi
CiAgICAgICAgICAgIC0gIjgwIDE2MCIKICAgICAgICAgICAgLSAiMTYwIDI0MCIKICAgICAg
ICAgICAgLSAiMjQwIDMyMCIKICAgICAgICAgICAgLSAiMzIwIDM0MCIKICAgICAgICAgICAg
LSAiMzQwIDQwMCIKICAgICAgICAgIHNjcmF0Y2hfZGV2czoKICAgICAgICAgICAgLSBwMQog
ICAgICAgICAgICAtIHAyCiAgICAgICAgICAgIC0gcDMKICAgICAgICAgICAgLSBwNAogICAg
ICBmaWxlc3lzdGVtczoKICAgICAgICBudm1lMG4xcDY6CiAgICAgICAgICBkZXZpY2U6ICIv
ZGV2L252bWUwbjFwNiIKICAgICAgICAgIGZzdHlwZTogeGZzCiAgICAgICAgICBtb3VudHBv
aW50OiAiL3Zhci9jYWNoZS9mc2NhY2hlIgo=
--------------2F43AC79ECBA8D2455A52B38
Content-Type: application/x-yaml;
 name="fscache-gibba.yml"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fscache-gibba.yml"

b3ZlcnJpZGVzOgogIGFuc2libGUuY2VwaGxhYjoKICAgIHNraXBfdGFnczogbHZtCiAgICB2
YXJzOgogICAgICB2YXJfbGliX3BhcnRpdGlvbjogIi9kZXYvbnZtZTBuMXA1IgogICAgICBj
b25maWd1cmVfY2FjaGVmaWxlc2Q6IHRydWUKICAgICAgZHJpdmVzX3RvX3BhcnRpdGlvbjoK
ICAgICAgICBudm1lMG4xOgogICAgICAgICAgZGV2aWNlOiAiL2Rldi9udm1lMG4xIgogICAg
ICAgICAgdW5pdDogIiUiCiAgICAgICAgICBzaXplczoKICAgICAgICAgICAgLSAiMCAyMCIK
ICAgICAgICAgICAgLSAiMjAgNDAiCiAgICAgICAgICAgIC0gIjQwIDYwIgogICAgICAgICAg
ICAtICI2MCA4MCIKICAgICAgICAgICAgLSAiODAgODciCiAgICAgICAgICAgIC0gIjg3IDEw
MCIKICAgICAgICAgIHNjcmF0Y2hfZGV2czoKICAgICAgICAgICAgLSBwMQogICAgICAgICAg
ICAtIHAyCiAgICAgICAgICAgIC0gcDMKICAgICAgICAgICAgLSBwNAogICAgICBmaWxlc3lz
dGVtczoKICAgICAgICBudm1lMG4xcDY6CiAgICAgICAgICBkZXZpY2U6ICIvZGV2L252bWUw
bjFwNiIKICAgICAgICAgIGZzdHlwZTogeGZzCiAgICAgICAgICBtb3VudHBvaW50OiAiL3Zh
ci9jYWNoZS9mc2NhY2hlIgo=
--------------2F43AC79ECBA8D2455A52B38--

