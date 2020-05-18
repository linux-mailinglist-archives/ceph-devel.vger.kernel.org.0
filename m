Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816A31D7270
	for <lists+ceph-devel@lfdr.de>; Mon, 18 May 2020 10:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgERIDV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 May 2020 04:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgERIDV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 May 2020 04:03:21 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CE4C061A0C
        for <ceph-devel@vger.kernel.org>; Mon, 18 May 2020 01:03:21 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id g25so1579695otp.13
        for <ceph-devel@vger.kernel.org>; Mon, 18 May 2020 01:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=VuAa901pJuuVRwPCc1GOUySmte9Q302p55RYAg49YlM=;
        b=TPoGjwyueFI+Eb0V/pT8LfsNRu9YxMu4YqCAB9dpM9+PB1j4YhX96jEj2mMQbyZLc+
         rXi5uZc/4m9/IyC6JG2MAKr/W5BxELwWcOOh716hFPjml9F2yE+k9cddqGL1ZuDh9Y17
         aAKp6XC31v7VZckorSqonBPPi2I3RRazCu0872YT4cumc6o0HoF6T1jtVQwC+TPPnVLj
         Txlu9SJwyqYxa3f0fia3m+xxVH5R51CwGcGKMZe7zIJ1gOXz22KEzqS5UceE0DhRt59E
         pr1oOBgekkZH7LP3ii1GeEI79w4JX059GONu1NiSSnEd9WgHlDRIUdKqXweymvDuhSRm
         IzEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VuAa901pJuuVRwPCc1GOUySmte9Q302p55RYAg49YlM=;
        b=SNtQVI5mHp68KH5RjJYqlBl1poec5b67K20gyqkH80EZJbrFYzd99SBtOTan52Lyit
         bAmbHxmfiEfnU38UzoGuA0KtBVKGDYf2fLsXytzITT1oCpUbpC0I1wvknHouxUwgnVpS
         MU+lgNyZnqjBRUAwoHrucy0Sw1lg6JQfmgVPJGciHmLBwj7ewnPrCf4ubVm91VAh2b6J
         V5W+1sJSuvncB/OKwUxD7AJ5eJimXIRFEjDnf2xxTV0xNPQun9+Y+dgAOYGkFZuVZQ9H
         ppZr0FIFY5I7ExcjdHqcRl6xtZljlCVSf06jjhVxVqzU0GqyMCrMws76cL6NUcdsvGXL
         e+wQ==
X-Gm-Message-State: AOAM530RiMpa84eXzNWUhOOScadvHGQweNBt3Ae7tlj9xz89P40BVUnl
        83jB3AABUZsIPkZxS3aWjFDAgkGE2+w9WMVn859B8pGe
X-Google-Smtp-Source: ABdhPJyizLPtWRmdn9Tq6OtVsNHNV3HNAGDffJqXojrc+ceZcMLhQrcuzQOHT9GE0+pgrsBEs7h6svNqQ2PaPvWsxJw=
X-Received: by 2002:a9d:e88:: with SMTP id 8mr11026303otj.257.1589789000668;
 Mon, 18 May 2020 01:03:20 -0700 (PDT)
MIME-Version: 1.0
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Mon, 18 May 2020 16:03:09 +0800
Message-ID: <CAKQB+fug_Y4y8wYe-vG=itf+0BmYFPfDm-ch7DTobtkipQz-yw@mail.gmail.com>
Subject: [PATCH] libceph: add ignore cache/overlay flag if got redirect reply
To:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

osd client should ignore cache/overlay flag if got redirect reply.
Otherwise, the client hangs when the cache tier is in forward mode.

Similar issues:
   https://tracker.ceph.com/issues/23296
   https://tracker.ceph.com/issues/36406

Signed-off-by: Jerry Lee <leisurelysw24@gmail.com>
---
 net/ceph/osd_client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 998e26b..1d4973f 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3649,7 +3649,9 @@ static void handle_reply(struct ceph_osd *osd,
struct ceph_msg *msg)
                 * supported.
                 */
                req->r_t.target_oloc.pool = m.redirect.oloc.pool;
-               req->r_flags |= CEPH_OSD_FLAG_REDIRECTED;
+               req->r_flags |= CEPH_OSD_FLAG_REDIRECTED |
+                               CEPH_OSD_FLAG_IGNORE_OVERLAY |
+                               CEPH_OSD_FLAG_IGNORE_CACHE;
                req->r_tid = 0;
                __submit_request(req, false);
                goto out_unlock_osdc;
