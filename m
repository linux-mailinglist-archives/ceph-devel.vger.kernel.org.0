Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77A719FE35
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Apr 2020 21:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgDFTmc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Apr 2020 15:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbgDFTmc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Apr 2020 15:42:32 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5C38206F5;
        Mon,  6 Apr 2020 19:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586202151;
        bh=6SYF+YLewF9/EuJnTdqnXrCyGg94aJKIi/n17oHrvDg=;
        h=From:To:Cc:Subject:Date:From;
        b=x8Xg34dBZZCr2+q2NNwi4tiQ8vdiAufHYsCWhZ8pgPCACFcjGFcyX6E/hzITesEod
         ItTCn/wM7yn60Ux+plpGTgL8QaeLokByqIyc7ADGM0i+OSxBhXeHQNy/L2nPcmH08Z
         Qfsq3MIit3yryXPASHzwKnMxur8zYuMIiw7AI5uo=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        jfajerski@suse.com, lhenriques@suse.com, gfarnum@redhat.com
Subject: [PATCH v3 0/2] ceph: fix long stalls on sync/syncfs
Date:   Mon,  6 Apr 2020 15:42:26 -0400
Message-Id: <20200406194228.52418-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Just a small update from the last version. This adds a new helper
function to handle moving the inode to the appropriate lists when
auth caps change.

Also, remove a FIXME comment I had added as I think I've answered
the question on that for now (and a later patch will fix it).

Jeff Layton (2):
  ceph: convert mdsc->cap_dirty to a per-session list
  ceph: request expedited service on session's last cap flush

 fs/ceph/caps.c       | 86 ++++++++++++++++++++++++++++++++++++--------
 fs/ceph/mds_client.c |  2 +-
 fs/ceph/mds_client.h |  5 +--
 fs/ceph/super.h      | 19 ++++++++--
 4 files changed, 91 insertions(+), 21 deletions(-)

-- 
2.25.1

