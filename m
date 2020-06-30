Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F51220FDD3
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jun 2020 22:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgF3UiG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jun 2020 16:38:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55636 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729704AbgF3UiF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Jun 2020 16:38:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593549483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
        bh=EyefK15cpq+Cvj66mdBKZGcm4rMEx/fYRYj7VS4bzGE=;
        b=L8UNAZnFTSvA4kfX8nh68AtpBHXceW/abSNND070gdj29Yas8FXVajaH/NgraBykyTcLFR
        kQM/M1rIhkhGxJdmmrIqsWj4ddDrUwRITGFW0A1abyy6OmDJ2PFImgofhRHZcmTLJLb98M
        Z9Uoj7vwFmNCTr75XMWsswUqELsi4VM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-tLQDw4zZMXqYfpBSQVmy-A-1; Tue, 30 Jun 2020 16:37:35 -0400
X-MC-Unique: tLQDw4zZMXqYfpBSQVmy-A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEC3DEC1AF;
        Tue, 30 Jun 2020 20:37:33 +0000 (UTC)
Received: from [10.10.118.98] (ovpn-118-98.rdu2.redhat.com [10.10.118.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4793F2B4C2;
        Tue, 30 Jun 2020 20:37:33 +0000 (UTC)
From:   David Galloway <dgallowa@redhat.com>
Subject: v15.2.4 Octopus released
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel <ceph-devel@vger.kernel.org>, ceph-maintainers@ceph.io
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
Message-ID: <d21c2b58-1191-5e5f-3df1-a84d42750b48@redhat.com>
Date:   Tue, 30 Jun 2020 16:37:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We're happy to announce the fourth bugfix release in the Octopus series.
In addition to a security fix in RGW, this release brings a range of fixes
across all components. We recommend that all Octopus users upgrade to this
release. For a detailed release notes with links & changelog please
refer to the official blog entry at https://ceph.io/releases/v15-2-4-octopus-released

Notable Changes
---------------
* CVE-2020-10753: rgw: sanitize newlines in s3 CORSConfiguration's ExposeHeader
  (William Bowling, Adam Mohammed, Casey Bodley)

* Cephadm: There were a lot of small usability improvements and bug fixes:
  * Grafana when deployed by Cephadm now binds to all network interfaces.
  * `cephadm check-host` now prints all detected problems at once.
  * Cephadm now calls `ceph dashboard set-grafana-api-ssl-verify false`
    when generating an SSL certificate for Grafana.
  * The Alertmanager is now correctly pointed to the Ceph Dashboard
  * `cephadm adopt` now supports adopting an Alertmanager
  * `ceph orch ps` now supports filtering by service name
  * `ceph orch host ls` now marks hosts as offline, if they are not
    accessible.

* Cephadm can now deploy NFS Ganesha services. For example, to deploy NFS with
  a service id of mynfs, that will use the RADOS pool nfs-ganesha and namespace
  nfs-ns::

    ceph orch apply nfs mynfs nfs-ganesha nfs-ns

* Cephadm: `ceph orch ls --export` now returns all service specifications in
  yaml representation that is consumable by `ceph orch apply`. In addition,
  the commands `orch ps` and `orch ls` now support `--format yaml` and
  `--format json-pretty`.

* Cephadm: `ceph orch apply osd` supports a `--preview` flag that prints a preview of
  the OSD specification before deploying OSDs. This makes it possible to
  verify that the specification is correct, before applying it.

* RGW: The `radosgw-admin` sub-commands dealing with orphans --
  `radosgw-admin orphans find`, `radosgw-admin orphans finish`, and
  `radosgw-admin orphans list-jobs` -- have been deprecated. They have
  not been actively maintained and they store intermediate results on
  the cluster, which could fill a nearly-full cluster.  They have been
  replaced by a tool, currently considered experimental,
  `rgw-orphan-list`.

* RBD: The name of the rbd pool object that is used to store
  rbd trash purge schedule is changed from "rbd_trash_trash_purge_schedule"
  to "rbd_trash_purge_schedule". Users that have already started using
  `rbd trash purge schedule` functionality and have per pool or namespace
  schedules configured should copy "rbd_trash_trash_purge_schedule"
  object to "rbd_trash_purge_schedule" before the upgrade and remove
  "rbd_trash_purge_schedule" using the following commands in every RBD
  pool and namespace where a trash purge schedule was previously
  configured::

    rados -p <pool-name> [-N namespace] cp rbd_trash_trash_purge_schedule rbd_trash_purge_schedule
    rados -p <pool-name> [-N namespace] rm rbd_trash_trash_purge_schedule

  or use any other convenient way to restore the schedule after the
  upgrade.

Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-14.2.10.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 7447c15c6ff58d7fce91843b705a268a1917325c

-- 
David Galloway
Systems Administrator, RDU
Ceph Engineering
IRC: dgalloway

