Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BAA2D4989
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Dec 2020 19:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbgLISyo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Dec 2020 13:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbgLISyh (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 13:54:37 -0500
From:   Jeff Layton <jlayton@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, xiubli@redhat.com, idryomov@gmail.com
Subject: [PATCH 0/4] ceph: implement later versions of MClientRequest headers
Date:   Wed,  9 Dec 2020 13:53:50 -0500
Message-Id: <20201209185354.29097-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

A few years ago, userland ceph added support for changing the birthtime
via setattr, as well as support for sending supplementary groups in a
MDS request.

This patchset updates the kclient to use the newer protocol. The
necessary structures are extended and the code is changed to support the
newer formats when it detects that the MDS will support it.

Supplementary groups will now be transmitted in the request, but for now
the setting of btime is not implemented.

This is a prerequisite step to adding support for the new "alternate
name" field that Xiubo has been working on, which we'll need for
proper fscrypt support.

Jeff Layton (4):
  ceph: don't reach into request header for readdir info
  ceph: take a cred reference instead of tracking individual uid/gid
  ceph: clean up argument lists to __prepare_send_request and
    __send_request
  ceph: implement updated ceph_mds_request_head structure

 fs/ceph/inode.c              |  5 +-
 fs/ceph/mds_client.c         | 98 ++++++++++++++++++++++++++----------
 fs/ceph/mds_client.h         |  3 +-
 include/linux/ceph/ceph_fs.h | 32 +++++++++++-
 4 files changed, 106 insertions(+), 32 deletions(-)

-- 
2.29.2

