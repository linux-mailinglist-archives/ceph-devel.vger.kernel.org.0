Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD59C2DCB1E
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Dec 2020 03:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgLQCzK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Dec 2020 21:55:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727095AbgLQCzK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 21:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608173623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=qI7n1z247snzkwfSD/V0bRM+AJkrKaJGWDQzFgEXAxQ=;
        b=aAnowc9iLLCy9YiB3/oFBa/zG2iNVAWWXh6YMJNcP8OMQLHdrQ/FPBIdAgRln0KXfkmrpx
        QQytS0iiVH5PjaflMIxbt3CnsvHKCyZzkinvJTIO3espu1IuJ8RYyDdLaZHYxCY/LG5ANa
        xPeo/9YNMGf3GgZAG5XJvfA12klQuS4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-ifwaADz9PJeRYHvXZk-rgg-1; Wed, 16 Dec 2020 21:53:34 -0500
X-MC-Unique: ifwaADz9PJeRYHvXZk-rgg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4F93800D53;
        Thu, 17 Dec 2020 02:53:32 +0000 (UTC)
Received: from [10.10.116.68] (ovpn-116-68.rdu2.redhat.com [10.10.116.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BC7D19CAC;
        Thu, 17 Dec 2020 02:53:32 +0000 (UTC)
Subject: v15.2.8 Octopus released
From:   David Galloway <dgallowa@redhat.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel <ceph-devel@vger.kernel.org>, ceph-maintainers@ceph.io
References: <d21c2b58-1191-5e5f-3df1-a84d42750b48@redhat.com>
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
Message-ID: <969c76d1-d3a7-e103-0206-e4cc410df455@redhat.com>
Date:   Wed, 16 Dec 2020 21:53:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d21c2b58-1191-5e5f-3df1-a84d42750b48@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We're happy to announce the 8th backport release in the Octopus series. This release fixes a security flaw in CephFS and includes a number of bug fixes. We recommend users to update to this release. For a detailed release notes with links & changelog please refer to the official blog entry at https://ceph.io/releases/v15-2-8-octopus-released

Notable Changes
---------------

* CVE-2020-27781 : OpenStack Manila use of ceph_volume_client.py library allowed
  tenant access to any Ceph credential's secret. (Kotresh Hiremath Ravishankar,
  Ramana Raja)

* ceph-volume: The `lvm batch` subcommand received a major rewrite. This closed
  a number of bugs and improves usability in terms of size specification and
  calculation, as well as idempotency behaviour and disk replacement process.
  Please refer to https://docs.ceph.com/en/latest/ceph-volume/lvm/batch/ for
  more detailed information.

* MON: The cluster log now logs health detail every `mon_health_to_clog_interval`,
  which has been changed from 1hr to 10min. Logging of health detail will be
  skipped if there is no change in health summary since last known.

* The `ceph df` command now lists the number of pgs in each pool.

* The `bluefs_preextend_wal_files` option has been removed.

* It is now possible to specify the initial monitor to contact for Ceph tools
  and daemons using the `mon_host_override` config option or
  `--mon-host-override <ip>` command-line switch. This generally should only
  be used for debugging and only affects initial communication with Ceph's
  monitor cluster.

Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-15.2.8.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: bdf3eebcd22d7d0b3dd4d5501bee5bac354d5b55

