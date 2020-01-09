Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17C213575C
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 11:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgAIKs3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 05:48:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:60676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729328AbgAIKs3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 05:48:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 406A96A21E;
        Thu,  9 Jan 2020 10:48:22 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org
Subject: v14.2.6 Nautilus released
Date:   Thu, 09 Jan 2020 11:48:22 +0100
Message-ID: <87a76w6h3d.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


We're happy to announce the availability of the sixth update to the Ceph
Nautilus release series. This is a hotfix release primarily fixing a
regression introduced in v14.2.5, all nautilus users are advised to
upgrade to this release. 

Notable Changes
---------------

* This release fixes a `ceph-mgr` bug that caused mgr becoming unresponsive on
  larger clusters issue#43364 https://tracker.ceph.com/issues/43364, pr#32466 (https://github.com/ceph/ceph/pull/32466 David Zafman, Neha Ojha)

The release notes can be also found at https://ceph.io/releases/v14-2-6-nautilus-released/

Getting Ceph
------------

* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-14.2.6.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: f0aa067ac7a02ee46ea48aa26c6e298b5ea272e9

--
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
