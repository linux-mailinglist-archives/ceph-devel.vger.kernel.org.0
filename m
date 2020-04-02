Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0A119C02A
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Apr 2020 13:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388119AbgDBL3O (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Apr 2020 07:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388049AbgDBL3N (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 2 Apr 2020 07:29:13 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5DA020787;
        Thu,  2 Apr 2020 11:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585826953;
        bh=RivXlthOU4yXPfSCxR5UeQ2hul1fHuuCsZihae8MDvs=;
        h=From:To:Cc:Subject:Date:From;
        b=ShscKwCbF5lhQc8E+sZNs/dkGgMdi7u1xNpWVd/cPdNEC2ccgkxVl7YD2ZUDRZmMB
         xqoNQZibH81h6ZjC66tHnXHsbU5mlQAwxS7pJOWTb5RdajWTVhk5Qbkb0bH91RoWt+
         EIFjf5Eq32g12r1E+UrMAfHPl+o5KTP78rebqcV0=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        jfajerski@suse.com, lhenriques@suse.com, gfarnum@redhat.com
Subject: [PATCH v2 0/2] ceph: fix long stalls on sync/syncfs
Date:   Thu,  2 Apr 2020 07:29:09 -0400
Message-Id: <20200402112911.17023-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is v2 of the patch I sent the other day to fix the problem of long
stalls when calling sync or syncfs.

This set converts the mdsc->cap_dirty list to a per-session list, and
then has the only caller that looks at cap_dirty walk the list of
sessions and issue flushes for each session in turn.

With this, we can use an empty s_cap_dirty list as an indicator that the
cap flush is the last one going to the session and can mark that one as
one we're waiting on so the MDS can expedite it.

This also attempts to clarify some of the locking around s_cap_dirty,
and adds a FIXME comment to raise the question about locking around
s_cap_flushing.

Jeff Layton (2):
  ceph: convert mdsc->cap_dirty to a per-session list
  ceph: request expedited service on session's last cap flush

 fs/ceph/caps.c       | 72 +++++++++++++++++++++++++++++++++++++++-----
 fs/ceph/mds_client.c |  2 +-
 fs/ceph/mds_client.h |  5 +--
 fs/ceph/super.h      | 21 +++++++++++--
 4 files changed, 87 insertions(+), 13 deletions(-)

-- 
2.25.1

