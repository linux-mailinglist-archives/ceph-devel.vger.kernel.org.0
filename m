Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD842CA6EF
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Dec 2020 16:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390454AbgLAPXm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Dec 2020 10:23:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390217AbgLAPXl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Dec 2020 10:23:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606836134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=dGAKTzzd3J8uwrwSjKoMpzBLA4C++JWBicf5KjEgFOw=;
        b=Ea5Pv23jSaC/unj6bVzTvOh2HfcR2g4qxpjWJjHfyPV1s+lQnaHkJPS2p1zN4R3Fe5kjbS
        cEYsHVW/NcFc7nDyEOj63UJ+f45lRj3ZKKQ1mUFD6Ql1IjzGbmPDrotTcTjmskq7lHraTx
        9G2MP8gsf/sKscpLgX/n4KJjI4m4s14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-jaKh9l1OMq6rZKoWEt3KLA-1; Tue, 01 Dec 2020 10:22:11 -0500
X-MC-Unique: jaKh9l1OMq6rZKoWEt3KLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29278423B8;
        Tue,  1 Dec 2020 15:22:10 +0000 (UTC)
Received: from [10.10.114.245] (ovpn-114-245.rdu2.redhat.com [10.10.114.245])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C6C1060854;
        Tue,  1 Dec 2020 15:22:09 +0000 (UTC)
Subject: Re: provisioning clients in teuthology with an extra local filesystem
To:     Jeff Layton <jlayton@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        sepia <sepia@ceph.io>
References: <36b421ea14b3b14226b3e7c0407876886bb74e08.camel@redhat.com>
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
Message-ID: <ad5a9630-daa0-b379-c7f4-5a9a139cd3a5@redhat.com>
Date:   Tue, 1 Dec 2020 10:22:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <36b421ea14b3b14226b3e7c0407876886bb74e08.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 12/1/20 9:55 AM, Jeff Layton wrote:
> I've been working on a patch series to overhaul the fscache code in the
> kclient. I also have this (really old) tracker to add fscache testing to
> teuthology:
> 
>     https://tracker.ceph.com/issues/6373
> 
> It would be ideal if the clients in such testing had a dedicated
> filesystem mounted on /var/cache/fscache, so that if it fills up it
> doesn't take down the rootfs with it. We'll also need to have
> cachefilesd installed and running in the client hosts.
> 
> Is it possible to do this in teuthology? How would I approach this?
> 

I think I can make this happen pretty easily in ceph-cm-ansible.  What
I'd need from you is desired filesystem type and size.  Once I'm done
with my end, we'll need to create a cephlab.ansible overrides yaml
fragment to stick in that suite's qa directory.

