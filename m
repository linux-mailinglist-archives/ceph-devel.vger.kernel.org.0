Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F76D448094
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 14:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbhKHNxc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 08:53:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237427AbhKHNxa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Nov 2021 08:53:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636379445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=W5eWQxoBYDXQQzmHozBaOjZ4Hvv8LetSKK8Xjpq1Q5o=;
        b=hzqiaXKyXT8sWu8sG0ji7cfOgNqCmdwpXvu0bPRDgwVRmGvqaRL9IZDHVdu3Rjm54iM/aM
        bubSylXLY+DW27XdB7qkUCZD+bbKIeutCArZOZCga6/MJRn/+rPsHD3+YatiD+k3T+E59c
        FFEhyfTObeD8pbgn/W0lyYvsWUR28Jw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-o9mu4p2KPo6cwaHGJPnVaQ-1; Mon, 08 Nov 2021 08:50:44 -0500
X-MC-Unique: o9mu4p2KPo6cwaHGJPnVaQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B18D80A5C3;
        Mon,  8 Nov 2021 13:50:43 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1DC979459;
        Mon,  8 Nov 2021 13:50:38 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size handling
Date:   Mon,  8 Nov 2021 21:50:10 +0800
Message-Id: <20211108135012.79941-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Hi Jeff,

The #1 could be squashed to the previous "ceph: add truncate size handling support for fscrypt" commit.
The #2 could be squashed to the previous "ceph: fscrypt_file field handling in MClientRequest messages" commit.

Thanks.

Xiubo Li (2):
  ceph: fix possible crash and data corrupt bugs
  ceph: there is no need to round up the sizes when new size is 0

 fs/ceph/inode.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

-- 
2.27.0

