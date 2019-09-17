Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C049BB5025
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Sep 2019 16:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfIQOQY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Sep 2019 10:16:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:48252 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726308AbfIQOQY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 10:16:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 36BDCB670;
        Tue, 17 Sep 2019 14:16:23 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.com, ceph-maintainers@ceph.com,
        ceph-users@ceph.com, dev@ceph.io, ceph-devel@vger.kernel.org
Subject: v14.2.4 Nautilus released
Date:   Tue, 17 Sep 2019 16:16:22 +0200
Message-ID: <87ef0fc8jt.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is the fourth release in the Ceph Nautilus stable release series. Its sole
purpose is to fix a regression that found its way into the previous release.

Notable Changes
---------------
The ceph-volume in Nautilus v14.2.3 was found to contain a serious
regression, described in https://tracker.ceph.com/issues/41660, which
prevented deployment tools like ceph-ansible, DeepSea, Rook, etc. from
deploying/removing OSDs.

Getting Ceph
------------

* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-14.2.3.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 75f4de193b3ea58512f204623e6c5a16e6c1e1ba

--
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH

