Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7353150636
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 13:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgBCMba (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 07:31:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:42874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgBCMba (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 07:31:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC1D5B04F;
        Mon,  3 Feb 2020 12:31:28 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org
Subject: v14.2.7 Nautilus released 
Date:   Mon, 03 Feb 2020 13:31:28 +0100
Message-ID: <87d0avetsv.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is the seventh update to the Ceph Nautilus release series. This is
a hotfix release primarily fixing a couple of security issues. We
recommend that all users upgrade to this release.

Notable Changes
---------------

* CVE-2020-1699: Fixed a path traversal flaw in Ceph dashboard that
  could allow for potential information disclosure (Ernesto Puerta)
* CVE-2020-1700: Fixed a flaw in RGW beast frontend that could lead to
  denial of service from an unauthenticated client (Or Friedmann)

Blog Link: https://ceph.io/releases/v14-2-7-nautilus-released/

Getting Ceph
------------

* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-14.2.7.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 3d58626ebeec02d8385a4cefb92c6cbc3a45bfe8

-- 
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
