Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B42A1B643F
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Apr 2020 21:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgDWTJh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Thu, 23 Apr 2020 15:09:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:58922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDWTJh (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 Apr 2020 15:09:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4271FAE3C;
        Thu, 23 Apr 2020 19:09:35 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org, ceph-maintainers@ceph.io
Subject: v13.2.10 Mimic released
Date:   Thu, 23 Apr 2020 21:09:35 +0200
Message-ID: <87blniqas0.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


We're happy to announce the availability of the tenth bugfix release of
Ceph Mimic, this release fixes a RGW vulnerability affecting mimic, and
we recommend that all mimic users upgrade.

Notable Changes
---------------
* CVE 2020 12059: Fix an issue with Post Object Requests with Tagging
  (#44967, Lei Cao, Abhishek Lekshmanan)


Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-13.2.10.tar.gz
* For packages: http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 564bdc4ae87418a232fc901524470e1a0f76d641
* Release blog: https://ceph.io/releases/v13-2-10-mimic-released

--
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
GF: Felix Imendörffer
