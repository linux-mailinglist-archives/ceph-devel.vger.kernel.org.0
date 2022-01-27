Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C3649DC87
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Jan 2022 09:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiA0I0q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Jan 2022 03:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237754AbiA0I0i (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Jan 2022 03:26:38 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CD5C061747
        for <ceph-devel@vger.kernel.org>; Thu, 27 Jan 2022 00:26:37 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id e20so2174611qvu.7
        for <ceph-devel@vger.kernel.org>; Thu, 27 Jan 2022 00:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nECOqKlyhW+9imcB3xRIqoX6CxsPOLkOaCAhjQWi4fs=;
        b=LnMDlwA5fVDVJvOr3kn4s/YBkOZ6NFTeCeV3NHfI9NBkSr5yL5gBCvTWBsf/1psO2S
         uEbu2YTeHhnekB4s4aMPWs9dnHRZxea7bYeufSjVTgaIfAcoS3NqmbpJrIGY3ctGiY8h
         cI608H2f0tfC/jK2LyGY4qMxIUCUTTdIwxEf0KGSrkbuNOR5lGiynK3XV1ZYhTD5aapG
         20HSAW3WSsgPkyTmHkUD6JnHYSEgklyz0tWG8Mkm9ctW6O2GdMOaorEeSlO+h/VRmNU3
         4xF5/LD9dlLei7XdWOHe6SeHd21AP8VomhAZ1lLu/tpR51wVlt6eyl7rAe0N0AAu4WAH
         HT8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nECOqKlyhW+9imcB3xRIqoX6CxsPOLkOaCAhjQWi4fs=;
        b=TZOZS7kvzj9BKY/s+/j3Faj0sGa6cQ2jxxKf4SWF/SlQA1Qt+ZSnrabcViweLHwmK1
         MQgEVOJqy0fG9YX/K8iGf/C8bKcBY9hO383OPl18brClzK3BK2U7BRf7U8rC6wmUyg8l
         YP9ICzPxHhjotW97LjdiYz1p8awnqojlyegAIdurJzMuDKkICkVdQLtV1dU0VmERc81E
         +zSfvDGKqaJzeBxK2jx2qen7RdUxju8JBvLbS/SWPIAX8IJ7SHOwRVgdSQY7PuZL9gw0
         PSb7xoJW5MWiuMsMkIJ3cSKfgEQIRBhHVG3GPgO5CivjN44AHpM6xASBqE8wSkDoBWtl
         5rCw==
X-Gm-Message-State: AOAM533lF5qDkqaF+3MTXRmBkTqHVbODAovSiV6FM3ULqyL4cdTyAF8W
        nsQawJRXO6THvPAa98FlZTs=
X-Google-Smtp-Source: ABdhPJy7eXdfXHPIaDHb03/JLAttbQvKY9yCeeRspBYdsRjU1CTeL8tO173yoa5JZBY9qwOqWrVwgg==
X-Received: by 2002:a05:6214:226b:: with SMTP id gs11mr1779210qvb.98.1643271996930;
        Thu, 27 Jan 2022 00:26:36 -0800 (PST)
Received: from vossi01.front.sepia.ceph.com ([8.43.84.3])
        by smtp.gmail.com with ESMTPSA id g1sm952953qtk.21.2022.01.27.00.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 00:26:36 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH v6 0/1] ceph: add support for getvxattr op
Date:   Thu, 27 Jan 2022 08:26:18 +0000
Message-Id: <20220127082619.85379-1-mchangir@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Changes to v6:
* only auth mds session is tested for presence of getvxattr feature
* removed function to test feature cluster-wide

Milind Changire (1):
  ceph: add getvxattr op

 fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c         | 27 ++++++++++++++++++-
 fs/ceph/mds_client.h         | 12 ++++++++-
 fs/ceph/strings.c            |  1 +
 fs/ceph/super.h              |  1 +
 fs/ceph/xattr.c              | 17 ++++++++++++
 include/linux/ceph/ceph_fs.h |  1 +
 7 files changed, 108 insertions(+), 2 deletions(-)

-- 
2.31.1

