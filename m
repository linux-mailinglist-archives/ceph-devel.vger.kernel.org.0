Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF56465F90
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2019 20:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbfGKSlk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Jul 2019 14:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730228AbfGKSlk (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 14:41:40 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64D54208E4;
        Thu, 11 Jul 2019 18:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562870500;
        bh=9KrGc9vmZg9XeQ6v6V3OOTCq+v+1ELj3+RlVF8LzS8U=;
        h=From:To:Cc:Subject:Date:From;
        b=zmMRN9Mta8apALH6c4mEEFxZb1sucJlCxLFiYxB2lpz1XF8MjnUxCnKJq+AppOx9g
         uS/nM/GbDOzEdbpvab3tLPALt6Szuc2zKnUTcqw/nJKDSz3wZwRTjrHmDqiEdWi6r7
         /3YzXUmRSuZiBWVPQfuTgIQfayOW/3t1nF+rC9Vk=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, idryomov@gmail.com, sage@redhat.com,
        lhenriques@suse.com
Subject: [PATCH v2 0/5] ceph: fix races when uninlining data
Date:   Thu, 11 Jul 2019 14:41:31 -0400
Message-Id: <20190711184136.19779-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v2: fix bugs that Luis pointed out
    close race window involving Uptodate flag
    have copy_file_range do uninlining
    dirty caps after updating i_inline_version

This is the second posting of this set. It closes some other race
windows, and should handle the cap dirtying better than the first.

The current code that handles uninlining data is racy. The uninlining
and the update of i_inline_version are not well coordinated, so one task
could end up uninlining the data and then performing a write to the OSD
and then a second task could end up uninlining the data again and
clobber the first task's write.

The first couple of patches do a little cleanup of the uninlining helper
code, and then the last patch fixes the potential race.

Jeff Layton (5):
  ceph: make ceph_uninline_data take inode pointer
  ceph: pass unlocked page to ceph_uninline_data
  ceph: fix potential races in ceph_uninline_data
  ceph: lock page before checking Uptodate flag
  ceph: handle inlined files in copy_file_range

 fs/ceph/addr.c  | 149 ++++++++++++++++++++++++++++++------------------
 fs/ceph/file.c  |  52 +++++++++--------
 fs/ceph/super.h |   2 +-
 3 files changed, 123 insertions(+), 80 deletions(-)

-- 
2.21.0

