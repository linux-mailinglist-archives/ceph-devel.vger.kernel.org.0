Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B3B1A0BEC
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Apr 2020 12:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgDGKaD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Apr 2020 06:30:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:48704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728360AbgDGKaC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 7 Apr 2020 06:30:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 063F4AC91;
        Tue,  7 Apr 2020 10:29:59 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Zheng Yan <zyan@redhat.com>
Cc:     Frank Schilder <frans@dtu.dk>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Henriques <lhenriques@suse.com>
Subject: [PATCH v2 0/2] ceph: support cross-quota-tree renames
Date:   Tue,  7 Apr 2020 11:30:18 +0100
Message-Id: <20200407103020.22588-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi!

The following patches will make the cephfs kernel client behave the same
way as the fuse client when doing renames across different quota realms.

Changes since v1:

- Dropped 'old == new' check in ceph_quota_check_rename() and added back
  optimization in ceph_rename(), to only check realms if old_dir and
  new_dir are different.

Luis Henriques (2):
  ceph: normalize 'delta' parameter usage in check_quota_exceeded
  ceph: allow rename operation under different quota realms

 fs/ceph/dir.c   |  9 +++----
 fs/ceph/quota.c | 62 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/ceph/super.h |  3 ++-
 3 files changed, 65 insertions(+), 9 deletions(-)

