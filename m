Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC7F19FB93
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Apr 2020 19:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbgDFR3w (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Apr 2020 13:29:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:59268 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbgDFR3w (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Apr 2020 13:29:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 66010B20D3;
        Mon,  6 Apr 2020 17:29:49 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Zheng Yan <zyan@redhat.com>
Cc:     Frank Schilder <frans@dtu.dk>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Henriques <lhenriques@suse.com>
Subject: [PATCH 0/2] ceph: support cross-quota-tree renames
Date:   Mon,  6 Apr 2020 16:11:59 +0100
Message-Id: <20200406151201.32432-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi!

The following patches will make the cephfs kernel client behave the same
way as the fuse client when doing renames across different quota realms.

Luis Henriques (2):
  ceph: normalize 'delta' parameter usage in check_quota_exceeded
  ceph: allow rename operation under different quota realms

 fs/ceph/dir.c   |  9 +++----
 fs/ceph/quota.c | 62 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/ceph/super.h |  3 ++-
 3 files changed, 65 insertions(+), 9 deletions(-)

