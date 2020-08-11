Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC0A242068
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Aug 2020 21:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgHKTiy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Tue, 11 Aug 2020 15:38:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:53498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgHKTiy (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 11 Aug 2020 15:38:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9D95CAB7D;
        Tue, 11 Aug 2020 19:39:14 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org, ceph-maintainers@ceph.io
Subject: v14.2.11 Nautilus released
Date:   Tue, 11 Aug 2020 21:38:41 +0200
Message-ID: <87imdpt1ku.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


We're happy to announce the availability of the eleventh release in the
Nautilus series. This release brings a number of bugfixes across all
major components of Ceph. We recommend that all Nautilus users upgrade
to this release.

Notable Changes
---------------
* RGW: The `radosgw-admin` sub-commands dealing with orphans --
  `radosgw-admin orphans find`, `radosgw-admin orphans finish`,
  `radosgw-admin orphans list-jobs` -- have been deprecated. They
  have not been actively maintained and they store intermediate
  results on the cluster, which could fill a nearly-full cluster.
  They have been replaced by a tool, currently considered
  experimental, `rgw-orphan-list`.

* Now when noscrub and/or nodeep-scrub flags are set globally or per pool,
  scheduled scrubs of the type disabled will be aborted. All user initiated
  scrubs are NOT interrupted.

* Fixed a ceph-osd crash in _committed_osd_maps when there is a failure to encode
  the first incremental map. issue#46443: https://github.com/ceph/ceph/pull/46443

For the detailed changelog please refer to the blog entry at
https://ceph.io/releases/v14-2-11-nautilus-released/

Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-14.2.11.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: f7fdb2f52131f54b891a2ec99d8205561242cdaf

--
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
GF: Felix Imendörffer, HRB 36809 (AG Nürnberg)
