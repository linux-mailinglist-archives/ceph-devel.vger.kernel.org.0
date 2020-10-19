Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E7C292820
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Oct 2020 15:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgJSN1t (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Oct 2020 09:27:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:55612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbgJSN1t (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 19 Oct 2020 09:27:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 90211ABCC;
        Mon, 19 Oct 2020 13:27:47 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 97cdfac5;
        Mon, 19 Oct 2020 13:27:51 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     Eryu Guan <guan@eryu.me>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org, Luis Henriques <lhenriques@suse.de>
Subject: [PATCH v2 0/3] Initial CephFS tests
Date:   Mon, 19 Oct 2020 14:27:47 +0100
Message-Id: <20201019132750.29293-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is my second attempt to have an initial set of ceph-specific tests
merged into fstests.  In this patchset I'm pushing a different set of
tests, focusing on the copy_file_range testing, although I *do* plan to
get back to the quota tests soon.

This syscall has a few peculiarities in ceph as it is able to use remote
object copies without the need to download/upload data from the OSDs.
However, in order to take advantage of this remote copy, the copy ranges 
and sizes need to include at least one object.  Thus, all the currently
existing generic tests won't actually take advantage of this feature.

Let me know any comments/concerns about this patchset.  Also note that
currently, in order to have cephfs copy_file_range to take advantage of
remote object copies, the additional 'copyfrom' mount parameter is
required; if not used, the copy will fallback to the default VFS
implementation.  (Hopefully this additional param will be dropped in the
future.)

Changes since v1:

- New _ceph_create_file_layout() function (in common/ceph) that creates
  and sets the file layout
- Added commit IDs relevant to tracker issue#37378 (test 002)
- Fixed tests file mode to 755

(Also clarified cover-letter text regarding the 'copyfrom' usage.)

Luis Henriques (3):
  ceph: add copy_file_range (remote copy operation) testing
  ceph: test combination of copy_file_range with truncate
  ceph: test copy_file_range with infile = outfile

 common/ceph        |  23 +++++
 common/rc          |   1 +
 tests/ceph/001     | 233 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ceph/001.out | 129 +++++++++++++++++++++++++
 tests/ceph/002     |  79 +++++++++++++++
 tests/ceph/002.out |   8 ++
 tests/ceph/003     | 116 ++++++++++++++++++++++
 tests/ceph/003.out |  11 +++
 tests/ceph/group   |   3 +
 9 files changed, 603 insertions(+)
 create mode 100644 common/ceph
 create mode 100755 tests/ceph/001
 create mode 100644 tests/ceph/001.out
 create mode 100755 tests/ceph/002
 create mode 100644 tests/ceph/002.out
 create mode 100755 tests/ceph/003
 create mode 100644 tests/ceph/003.out
 create mode 100644 tests/ceph/group

