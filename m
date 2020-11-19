Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9112B8A27
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Nov 2020 03:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgKSCi5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Nov 2020 21:38:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33600 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726457AbgKSCi4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 21:38:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605753535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
        bh=xfQ+AXMoY+cYJrqoXO2dsIsGiaKYtW37u/qvxf8/i68=;
        b=hEM9BJAuMsi+CvbWcXOYVDnFUxga+ReIX2qx7cTyZuZllVHsbE+CkbWLxKs3GBBmZ2uAFi
        6L/sQ2gdVxYha+WVPSvwRjN8tamgRP98Yq4P9nBfWelni9yp0gqpbA0IEyY/w/0oPSJ2mM
        svYO5LQZ++W4x06QyQB8fw9rhgZFqGg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-kIoqbb1EMQyu-9yhl1OKXg-1; Wed, 18 Nov 2020 21:38:48 -0500
X-MC-Unique: kIoqbb1EMQyu-9yhl1OKXg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19045100C676;
        Thu, 19 Nov 2020 02:38:47 +0000 (UTC)
Received: from [10.10.113.43] (ovpn-113-43.rdu2.redhat.com [10.10.113.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8707319930;
        Thu, 19 Nov 2020 02:38:46 +0000 (UTC)
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org, ceph-maintainers@ceph.io
From:   David Galloway <dgallowa@redhat.com>
Subject: v15.2.6 Octopus released
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
Message-ID: <9b6eefd1-e6f9-ddc2-2eed-6ecba00fb982@redhat.com>
Date:   Wed, 18 Nov 2020 21:38:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is the 6th backport release in the Octopus series. This releases
fixes a security flaw affecting Messenger V2 for Octopus & Nautilus. We
recommend users to update to this release.

Notable Changes
---------------
* CVE 2020-25660: Fix a regression in Messenger V2 replay attacks


Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-15.2.6.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: cb8c61a60551b72614257d632a574d420064c17a

