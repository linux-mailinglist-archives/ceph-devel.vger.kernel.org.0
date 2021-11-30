Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4106C4634CC
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Nov 2021 13:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhK3Myg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Nov 2021 07:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhK3Myg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Nov 2021 07:54:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C48C061574
        for <ceph-devel@vger.kernel.org>; Tue, 30 Nov 2021 04:51:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B823BB81919
        for <ceph-devel@vger.kernel.org>; Tue, 30 Nov 2021 12:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A502C53FC7;
        Tue, 30 Nov 2021 12:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638276674;
        bh=h2FAFcEQCp4qh2IcBhYM0JamPwxJ/Qal8Qs0suw3UjI=;
        h=From:To:Cc:Subject:Date:From;
        b=CBtPOOs16YQXMz387mX1RDV7Id2JWvfEAgDaX4sDst27JDdQDv3ZI2IzdyDb8RzTf
         LplVGs49Uj6gUlRiIZ7/rE39bv2BXX8LMcNqIh7NwIHRKLN83VvONjF8B/CGojA10s
         97Otw68RL/WeZdnrASNf7zjddL2ixNKTZnBxlEDHY2UMP1pYvhec4VrwUDb9h3MWA5
         n1TDooO2uK7TSYOSoC2WmKEEF5GhGFZyEK2zr1AP/cfsHLW8qrG/eKE+YshBTjcsgL
         4+t/x80g94m08L3G9GNYUDah4AWXhc0BBct51DU4xYb2JJGOa/KsmyF+rcFsKda4Ip
         YDtTTwBJKit7A==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com
Subject: [PATCH] ceph: drop send metrics debug message
Date:   Tue, 30 Nov 2021 07:51:12 -0500
Message-Id: <20211130125112.9710-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This pops every second and isn't very useful.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/metric.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index c57699d8408d..0fcba68f9a99 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -160,8 +160,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	msg->hdr.version = cpu_to_le16(1);
 	msg->hdr.compat_version = cpu_to_le16(1);
 	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
-	dout("client%llu send metrics to mds%d\n",
-	     ceph_client_gid(mdsc->fsc->client), s->s_mds);
 	ceph_con_send(&s->s_con, msg);
 
 	return true;
-- 
2.33.1

