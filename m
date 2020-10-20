Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C4329446A
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Oct 2020 23:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409798AbgJTVQx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 20 Oct 2020 17:16:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409790AbgJTVQw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 20 Oct 2020 17:16:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603228611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=FxZYvtpopXhpuV6m2NWe6jIRFmXZuXG645Bq6d4oQD0=;
        b=Lf3wumlDqiUk/A6OHiL6Q4VQ0BuNjJaREHuZBYdD0qp3vRacTUR/QJ2WSftrPWSsi20QTf
        NZbAw8gnJAGjEBROVRMEdQ4lbIe0rhKF6eq5AE5eXbDbqH4889jTO9KR0yWBruEyzfzo1w
        0LhIYBjD0QmZmP+cDaXDE/I9/UzUfD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-4QGa2-rlNUKaRRolosLWDQ-1; Tue, 20 Oct 2020 17:16:43 -0400
X-MC-Unique: 4QGa2-rlNUKaRRolosLWDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D3CE879517;
        Tue, 20 Oct 2020 21:16:42 +0000 (UTC)
Received: from [10.10.118.237] (ovpn-118-237.rdu2.redhat.com [10.10.118.237])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB3665C1C2;
        Tue, 20 Oct 2020 21:16:41 +0000 (UTC)
Subject: v14.2.12 Nautilus released
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
Message-ID: <e9160fd6-8663-5f3e-7f9f-ef2ac7f2c529@redhat.com>
Date:   Tue, 20 Oct 2020 17:16:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d21c2b58-1191-5e5f-3df1-a84d42750b48@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is the 12th backport release in the Nautilus series. This release
brings a number of bugfixes across all major components of Ceph. We
recommend that all Nautilus users upgrade to this release. For a
detailed release notes with links & changelog please
refer to the official blog entry at
https://ceph.io/releases/v14-2-12-nautilus-released


Notable Changes
---------------
* The `ceph df` command now lists the number of pgs in each pool.

* Monitors now have a config option `mon_osd_warn_num_repaired`, 10 by
default. If any OSD has repaired more than this many I/O errors in
stored data a `OSD_TOO_MANY_REPAIRS` health warning is generated. In
order to allow clearing of the warning, a new command `ceph tell osd.#
clear_shards_repaired [count]` has been added. By default it will set
the repair count to 0. If you wanted to be warned again if additional
repairs are performed you can provide a value to the command and specify
the value of `mon_osd_warn_num_repaired`. This command will be replaced
in future releases by the health mute/unmute feature.

* It is now possible to specify the initial monitor to contact for Ceph
tools and daemons using the `mon_host_override` config option or
`--mon-host-override <ip>` command-line switch. This generally should
only be used for debugging and only affects initial communication with
Ceph’s monitor cluster.


Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-14.2.12.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 2f3caa3b8b3d5c5f2719a1e9d8e7deea5ae1a5c6

