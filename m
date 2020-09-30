Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6774727E83D
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Sep 2020 14:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgI3MK2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Sep 2020 08:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbgI3MK2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 08:10:28 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8C252076B;
        Wed, 30 Sep 2020 12:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601467828;
        bh=ylycHcPnWpRCs3s4LMq6Ih36gBixAxSu/TsGGPmivAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uN/XejFbMAy/6xUWw8SJL8kLbfQt53wgIsDithP+k6KijMFe5ZdKJtjN2cs4ZtOqN
         Cpd/ogm5VkdYTiarp38VJ1mZNwGuGPvZCFP3hAUbeTIz/PQIgU5Z5y6mu+alRsAPyA
         RtGNeUSb9m/7nhgiwVyBNy2G9/giV90hC+1PqMUs=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [RFC PATCH v2 0/4] ceph: fix spurious recover_session=clean errors
Date:   Wed, 30 Sep 2020 08:10:21 -0400
Message-Id: <20200930121025.9257-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925140851.320673-1-jlayton@kernel.org>
References: <20200925140851.320673-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v2: fix handling of async requests in patch to queue requests

This is basically the same patchset as before, with a small revision to
the last patch to fix up the handling of async requests. With this
version, an async request will not be queued but instead will return
-EJUKEBOX so the caller can drive a synchronous request.

Original cover letter follows:

Ilya noticed that he would get spurious EACCES errors on calls done just
after blocklisting the client on mounts with recover_session=clean. The
session would get marked as REJECTED and that caused in-flight calls to
die with EACCES. This patchset seems to smooth over the problem, but I'm
not fully convinced it's the right approach.

The potential issue I see is that the client could take cap references to
do a call on a session that has been blocklisted. We then queue the
message and reestablish the session, but we may not have been granted
the same caps by the MDS at that point.

If this is a problem, then we probably need to rework it so that we
return a distinct error code in this situation and have the upper layers
issue a completely new mds request (with new cap refs, etc.)

Obviously, that's a much more invasive approach though, so it would be
nice to avoid that if this would suffice.

Jeff Layton (4):
  ceph: don't WARN when removing caps due to blocklisting
  ceph: don't mark mount as SHUTDOWN when recovering session
  ceph: remove timeout on allowing reconnect after blocklisting
  ceph: queue MDS requests to REJECTED sessions when CLEANRECOVER is set

 fs/ceph/caps.c       |  2 +-
 fs/ceph/mds_client.c | 23 ++++++++++++++---------
 fs/ceph/super.c      | 13 +++++++++----
 fs/ceph/super.h      |  1 -
 4 files changed, 24 insertions(+), 15 deletions(-)

-- 
2.26.2

