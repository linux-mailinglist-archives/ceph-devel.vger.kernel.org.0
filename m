Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDE81D10A
	for <lists+ceph-devel@lfdr.de>; Tue, 14 May 2019 23:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfENVLJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 May 2019 17:11:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfENVLI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 May 2019 17:11:08 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A206A3086273
        for <ceph-devel@vger.kernel.org>; Tue, 14 May 2019 21:11:08 +0000 (UTC)
Received: from [10.10.126.35] (ovpn-126-35.rdu2.redhat.com [10.10.126.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C2825D6A6
        for <ceph-devel@vger.kernel.org>; Tue, 14 May 2019 21:11:08 +0000 (UTC)
Subject: Re: All Jenkins builds halted
From:   David Galloway <dgallowa@redhat.com>
To:     ceph-devel <ceph-devel@vger.kernel.org>
References: <CAC-Np1zOhGgBcj3f7BartvhWneY0BNUtyh2hxE_+LXKXe5uEOg@mail.gmail.com>
 <3f6341f4-25f5-a8ec-7688-d3bf673bc6ab@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=dgallowa@redhat.com; prefer-encrypt=mutual; keydata=
 mQENBE60O2sBCADafZy0luRceto63vARvurZ7oepCBc+yBiDHHcFLmdZLs0nugjyYa1V1WW/
 j/tMPkjmQPGT1IcoXIrhppUXKrwXMkK4JB56GHI3cdximVuRMmHCY45ZbmAL7YnuNXz+5jbs
 iuzarsc9W3SyovQUx9n1lUymk1lASaPfNVdgzxl0/FHpKMhEqJGo0eQPh8o5M+ybZS9zXKNa
 QPiXJKLiHuise1hP4529ZTExjCqk+R3x6y7YwySKSFUhEVwY7ksU0rr/Xv5VVEsrLgS4nENe
 u9UQvJq2hp+RhgBH0ZV9+jLgwoYxjqbifJDlghbDPe7rhAfiD/xvoQFgAy/AOkVPRKHVABEB
 AAG0JERhdmlkIEdhbGxvd2F5IDxkZ2FsbG93YUByZWRoYXQuY29tPokBNwQTAQgAIQUCVfr6
 SAIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRA4J2vQ1bgO+m5hB/kBOH7I2uhhhvGH
 BzGFKSh/1C9NO8ECg5N//b7xu9EtQfoVgNODTYqpG0mhH9phV7Cvld5gAlX3YV/m4lgDwJH9
 5fcNB2x7M6OEY2kOI20DxBKxVDmamhmQLQzm2ZFqbfHwh/H6zq3jdXWCbp8LQ9uvta5qbsFp
 rU4sVg2AhKAPrvr2JoO7MLVCdNfRhwdJFwvxlc6ltilateChU5dHpy2/2aSM3794VLZXQZkD
 Ei5PIc9XrXOKqqpbwMuizlh/tNA0O1a3jY8ccl9rYpCyELa9nfGw1HxXmfj8hMtndf077Bat
 7AxNyUoLu8+C9vD2F0oqXGumYCkcXIoSyiDAPY2IuQENBE60O2sBCADlXsFRIss3rM3IW9dK
 8084c3kktyOyA0JO4cQtXglGVvmALIaqxLlQ8qabibmRgdozjh5YsYFIQwBasmD+0rZVEi7W
 OMc1pO/dbwAzlhzfmbAvkvzctB4CS2MP6RLkGR9MquiLAAWdfOiRoKeNkgSup8VlSPrvlXwF
 qsolEbH14LJGtJBF3uRUrhieyV+dQ5wE/UJCmuN/m1KWlZmcUeDbTefNM/NaWxSdycu27QyL
 PBMIS9bDHPoPAaPjRKoMr80aYbHLZxiXPXlP3wyfirWiN5jqL2mjcCqGqzAC2IPuWftD4oHr
 P+3w6cBi1noh1ps76iD37IUsU8tZgTX5sE8RABEBAAGJAR8EGAECAAkFAk60O2sCGwwACgkQ
 OCdr0NW4Dvq5ywf/ZEVxP1LOUnkab+B8ZDQs6L66bBMMuWaoUKp9ngdpSqKfSy6YnbmshKaE
 SkNBNlpVpdOweSBPnLx4ss2sksLwDxrQTxW71Zui67mUbdurhlkbsG1pM4c1sAcdqa7xG6nB
 +fkpwgn9bcvv3qQGuKDwit6fdIVnPRJckM1T8w8d0yG+0uNSzOhwKI6h8E0Za2ESLmTyfkr1
 FtSVF86xVAGMI8jMiccCzKfOlkP89ND84r5EDzeATa3Imv7xKCgcIlSuMQKk45506NFPQQlP
 nCTgp61XOM4EWjembxD6lWBXHltcm3K1dXvf3JbAxG7v2BSd0hRhnXfQdZoAzRJwYIHh2Q==
Message-ID: <782fe1f7-4301-0d4b-8090-7b9fec4970a8@redhat.com>
Date:   Tue, 14 May 2019 17:11:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <3f6341f4-25f5-a8ec-7688-d3bf673bc6ab@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 14 May 2019 21:11:08 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/14/19 12:21 PM, David Galloway wrote:
> 
> On 5/13/19 6:56 PM, Alfredo Deza wrote:
>> Hi,
>>
>> Just a quick note on Jenkins, we are undergoing a major outage which
>> we are trying to recover from. Our master jenkins was affected with a
>> malware, a new instance is being worked on and we expect this to be
>> fully operational tomorrow.
>>
>> This means *new* builds and repos, Github PR checks, and formal Ceph
>> releases are impacted.
>>
>> Once all systems are fully working, PRs will have to manually
>> re-trigger the jobs (I will follow up on how to do that).
>>
>> Thanks for your patience while we work on this.
>>
> 
> Hi all,
> 
> The finish line is in sight.
> 
> Both Jenkins masters have been resurrected on new hosts.  There's a lot
> of manual configuration that needs to be done on these even with
> Configuration As Code (ansible, plugins, etc.).
> 
> I will be implementing a monthly CI maintenance to keep Jenkins and its
> plugins up to date to avoid situations like this in the future.
> 
> We're still working through a few snags.  I don't think wip branches are
> being built from ceph-ci.git, for example.  We'll send an all clear when
> things are.. all clear.
> 
> Thanks for your patience.
> 

I believe we've worked out all the kinks.

As a reminder, if you need to force a build for a branch in ceph-ci.git,
you can simply 'git commit --amend --no-edit && git push -f origin
wip-YOURBRANCH'

If you run into any issues, please don't hesitate to contact me.
