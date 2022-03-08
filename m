Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4193F4D181C
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 13:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbiCHMn3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 07:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbiCHMn2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 07:43:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 155BD5FA4
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 04:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646743349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8f4DMeYXtvWxEQQnJ6duzL5//XWYpnxnfU4tkb+ram0=;
        b=NUJ2RMhAVSjt/Az22y4GYEplbSg/XOQQ+5uIkDMm2d7PxChvgVDdZz270euZJ2T+2Awqzz
        HXi+l+S8Ilw1nkb+OcYY4SXT9tM7cIgCWM3Fzyizx4BbU3ocxek2/xpvuZnsG54yIQJ4cO
        zUJd0fFxI2X3DLq2liWnZGxeRFM58gY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-83juws5QMje4Jwq9-dLJvg-1; Tue, 08 Mar 2022 07:42:27 -0500
X-MC-Unique: 83juws5QMje4Jwq9-dLJvg-1
Received: by mail-pj1-f69.google.com with SMTP id e14-20020a17090a684e00b001bf09ac2385so6826428pjm.1
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 04:42:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8f4DMeYXtvWxEQQnJ6duzL5//XWYpnxnfU4tkb+ram0=;
        b=lSbCQ6FjUBoNfvyTw8/gzpXjhtmKiTH0PW9Kly37yaCdoo9B3BIpjXAzCLeLBRb8lv
         Y4GKn2IIae7HGVo+XJmcPcaX4w6KXAWCtu46mysLnCKtP3JfXZvznqcYhB1sWeimn0u4
         DAa2wlnrgORI6qyaf5OG6PljKdoHvwUCENLvqkNl/GlbYqGG3zIQyjlobDBTKW1dScy/
         V/Vdx6GDzVGMP+37KZC2KRtIdV9sG+UkNCcstWchjeEIaAHfh0bK7VRcD+W6aDXcWTCJ
         BbDbjJ+vLPcp4mvzTWpD0VfFtvnSJROWOEwIRwdYSfQiq99wIg4FbhRjAh3c4Msgdeka
         aD8w==
X-Gm-Message-State: AOAM531eKIfPtqD8eGZoX3L/EltrKMify3p9V5nrhiD6SdEHJIuD8l0W
        29QQNM30reWTat5uIr14pd5EYuPpdE4DA6GPMfvFcr62BQU3Zkpshk7dxA5QY+dEZf02jTg15YU
        mZIj5pYBuV2ZOLRR1Dj9dYA==
X-Received: by 2002:a17:90a:1db:b0:1bf:711d:267a with SMTP id 27-20020a17090a01db00b001bf711d267amr4470511pjd.155.1646743346873;
        Tue, 08 Mar 2022 04:42:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy0a5vSrBJIx59wMQwhMmaisNGEnJ7SFkdCxC9i0AF331Lrx4pUZJ+F0h/5ax61dioCdkt7yA==
X-Received: by 2002:a17:90a:1db:b0:1bf:711d:267a with SMTP id 27-20020a17090a01db00b001bf711d267amr4470485pjd.155.1646743346603;
        Tue, 08 Mar 2022 04:42:26 -0800 (PST)
Received: from localhost.localdomain ([124.123.80.180])
        by smtp.gmail.com with ESMTPSA id o185-20020a6341c2000000b0036fb987b25fsm15344959pga.38.2022.03.08.04.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 04:42:25 -0800 (PST)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 0/4] ceph: forward average read/write/metadata latency
Date:   Tue,  8 Mar 2022 07:42:15 -0500
Message-Id: <20220308124219.771527-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v2
  - rename to_ceph_timespec() to ktime_to_ceph_timespec()
  - use ceph_encode_timespec64() helper

Jeff,

To apply these, please drop commit range f4bf256..840d9f0 from testing branch.

Right now, cumulative read/write/metadata latencies are tracked
and are periodically forwarded to the MDS. These meterics are not
particularly useful. A much more useful metric is the average latency
and standard deviation (stdev) which is what this series of patches
aims to do.

The userspace (libcephfs+tool) changes are here::

          https://github.com/ceph/ceph/pull/41397

Note that the cumulative latencies are still forwarded to the MDS but
the tool (cephfs-top) ignores it altogether.

Latency standard deviation is calculated in `cephfs-top` tool.

Venky Shankar (4):
  ceph: use ktime_to_timespec64() rather than jiffies_to_timespec64()
  ceph: track average r/w/m latency
  ceph: include average/stdev r/w/m latency in mds metrics
  ceph: use tracked average r/w/m latencies to display metrics in
    debugfs

 fs/ceph/debugfs.c |  5 ++--
 fs/ceph/metric.c  | 63 +++++++++++++++++++++++++++--------------------
 fs/ceph/metric.h  | 63 ++++++++++++++++++++++++++++++-----------------
 3 files changed, 79 insertions(+), 52 deletions(-)

-- 
2.31.1

