Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A675B286641
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 19:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgJGRwQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 13:52:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:39598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727293AbgJGRwP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 13:52:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D6169AD04;
        Wed,  7 Oct 2020 17:52:13 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 93f83a9d;
        Wed, 7 Oct 2020 17:52:14 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Subject: [PATCH 0/3] Initial CephFS tests (take 2)
Date:   Wed,  7 Oct 2020 18:52:09 +0100
Message-Id: <20201007175212.16218-1-lhenriques@suse.de>
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
currently, in order to enable copy_file_range in cephfs, the additional
'copyfrom' mount parameter is required.  (Hopefully this additional param
may be dropped in the future.)

Luis Henriques (3):
  ceph: add copy_file_range (remote copy operation) testing
  ceph: test combination of copy_file_range with truncate
  ceph: test copy_file_range with infile = outfile

 tests/ceph/001     | 233 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ceph/001.out | 129 +++++++++++++++++++++++++
 tests/ceph/002     |  74 ++++++++++++++
 tests/ceph/002.out |   8 ++
 tests/ceph/003     | 118 +++++++++++++++++++++++
 tests/ceph/003.out |  11 +++
 tests/ceph/group   |   3 +
 7 files changed, 576 insertions(+)
 create mode 100644 tests/ceph/001
 create mode 100644 tests/ceph/001.out
 create mode 100644 tests/ceph/002
 create mode 100644 tests/ceph/002.out
 create mode 100644 tests/ceph/003
 create mode 100644 tests/ceph/003.out
 create mode 100644 tests/ceph/group

