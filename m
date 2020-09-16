Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EE226C6A4
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Sep 2020 19:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgIPR5B (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Sep 2020 13:57:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:48880 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727647AbgIPRyS (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 13:54:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=cantorsusede;
        t=1600269011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jo/X5/Dvrczw/R8zqhUAJUBzfEHzT8xfSgrsPXBLduc=;
        b=bkw2NcmdqUzQ6stK0guvCtHrNhDrC50Aggo4bds9bGCdESpxuMD7vMAILE904eZZm+5fs1
        l9lVp+Rssd/sLU3X64D1gh3N/woIPfsdaZq/5VYUoKZVHZERZJvOebxOn+stCGx8WP+tn6
        3p1dVA4oFRkkW1e3/ZwA5JMHAyTtupo1leausldEfFtOLCeSc75WBspwt3nENuFvlceQgq
        e7Kaw42Tt4wI86QySYCLchoXAtUTjasWk5BDc9GX94UKZzjD5CE3zQQE61yarFb5p/Whmd
        IceIRHuDvW+UhifmgmXLfUV6Umnse5+9fmzuZSTcXcDkphcqaA9SyENh2MC08w==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AA3E1ABCC;
        Wed, 16 Sep 2020 15:10:26 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org, ceph-maintainers@ceph.io
Subject: v15.2.5 octopus released
Date:   Wed, 16 Sep 2020 17:10:11 +0200
Message-ID: <87een1g3l8.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


This is the fifth backport release of the Ceph Octopus stable release
series. This release brings a range of fixes across all components. We
recommend that all Octopus users upgrade to this release.=20

Notable Changes
---------------

* CephFS: Automatic static subtree partitioning policies may now be configu=
red
  using the new distributed and random ephemeral pinning extended attribute=
s on
  directories. See the documentation for more information:
  https://docs.ceph.com/docs/master/cephfs/multimds/

* Monitors now have a config option `mon_osd_warn_num_repaired`, 10 by defa=
ult.
  If any OSD has repaired more than this many I/O errors in stored data a
  `OSD_TOO_MANY_REPAIRS` health warning is generated.

* Now when noscrub and/or no deep-scrub flags are set globally or per pool,
  scheduled scrubs of the type disabled will be aborted. All user initiated
  scrubs are NOT interrupted.

* Fix an issue with osdmaps not being trimmed in a healthy cluster (
  issue#47297, pr#36981)

For the detailed changelog please refer to the blog entry at
https://ceph.io/releases/v15-2-5-octopus-released/

Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-15.2.5.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 2c93eff00150f0cc5f106a559557a58d3d7b6f1f

--=20
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
GF: Felix Imend=C3=B6rffer, HRB 36809 (AG N=C3=BCrnberg)
