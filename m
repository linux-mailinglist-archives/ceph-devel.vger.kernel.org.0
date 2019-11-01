Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFB4EBB8B
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Nov 2019 02:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfKABBd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Oct 2019 21:01:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47840 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727455AbfKABBd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 21:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572570091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:openpgp:openpgp:autocrypt:autocrypt;
        bh=HiB1gNmbkXsaxU36IpSBTBcYuG9yBUhldXjckIVTi9Y=;
        b=DesrBN8PSmYWAyRXPvzr2gA/hmuf11vWRewQSJWh14a3b99QLRAFXgvEc7FZSXKLHvwaNA
        gEYimRTOU5d1dZAfSmDypCmzCnL1iW5s69JVSfs72xuZMc1JOeSMOCbHwa8P8yfPv0jLYb
        P0WB9PJsBe75h+gwVHLScNRzm8THEzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-Qbxy6Xt0MQiiCsfrP2ShpQ-1; Thu, 31 Oct 2019 21:01:27 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FBC28017E0
        for <ceph-devel@vger.kernel.org>; Fri,  1 Nov 2019 01:01:26 +0000 (UTC)
Received: from [10.10.121.236] (ovpn-121-236.rdu2.redhat.com [10.10.121.236])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 497E25D6A7
        for <ceph-devel@vger.kernel.org>; Fri,  1 Nov 2019 01:01:26 +0000 (UTC)
To:     ceph-devel <ceph-devel@vger.kernel.org>
From:   David Galloway <dgallowa@redhat.com>
Subject: Jenkins outage today
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
Message-ID: <f5a5bb09-0bae-4e27-2a6e-775fa1e93c7c@redhat.com>
Date:   Thu, 31 Oct 2019 21:01:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: Qbxy6Xt0MQiiCsfrP2ShpQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

There was a Jenkins outage from 16:12 on 31OCT2019 until 01:00 1NOV2019
today.

The Openstack volume serving /var/lib/jenkins kept corrupting the XFS
filesystem so I had to create a new volume and restore /var/lib/jenkins
from this morning's daily backups.

You should be able to force push any branches you need built.

See https://status.sepia.ceph.com/incidents/3756 for more details.

--=20
David Galloway
Systems Administrator, RDU
Ceph Engineering
IRC: dgalloway

