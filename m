Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADD12BB2EF
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Nov 2020 19:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbgKTS1v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Nov 2020 13:27:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbgKTS1u (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 13:27:50 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D8582224C;
        Fri, 20 Nov 2020 18:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605896870;
        bh=ZkN2E5iC9yYgk2lvFGmuCNBM20ad7vKF98d/MtbSjdo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C9mbaJyaK+TSgajVEkvF5OigO8zMZ5JL4/zSJ1vYiqcNm8FrVp7CS7LnU5RIbnlGf
         T86AG0es4ZZtGw9/0KsB0jOhFXoKESYu3AJRC977+J80SwOb8Uv40JNd5wtfiC2khz
         uAZToXA3OdacK2nlImfuq8kboz5BcAGKrgtEZz8A=
Date:   Fri, 20 Nov 2020 12:27:55 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 026/141] ceph: Fix fall-through warnings for Clang
Message-ID: <36ade28cd060cf4920476fffefcc40e38ef1e205.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a couple
of warnings by explicitly adding a break and a goto statements instead
of just letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/ceph/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index a4d48370b2b3..e9b44f613932 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -631,10 +631,12 @@ static loff_t ceph_dir_llseek(struct file *file, loff_t offset, int whence)
 	switch (whence) {
 	case SEEK_CUR:
 		offset += file->f_pos;
+		break;
 	case SEEK_SET:
 		break;
 	case SEEK_END:
 		retval = -EOPNOTSUPP;
+		goto out;
 	default:
 		goto out;
 	}
-- 
2.27.0

