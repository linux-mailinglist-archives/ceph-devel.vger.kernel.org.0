Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128C34B6746
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 10:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbiBOJRR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 04:17:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235747AbiBOJRR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 04:17:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92FF6AE54
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 01:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644916626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VnPiU1Qy3yqpU/b3Z9r+xuf1edGX1aazobnu8piUvc0=;
        b=evYE9Jntv8DNnxpUxrXzbyeyqfWfWXGMFun6+IS3jZxg/Vx6hnE4P0HEpFWbIDVRLSzZC3
        C0mhz24ax1+1wWh5+qhGulehl4EvyehO2x6KT8tY++5dOVGguA9i8gL7regpSGBgq8lcR6
        l/K90mBW01EpuN8Jb8d7dceKsfNgsRE=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-gcRW4c0pMlCUgZHUHMbomg-1; Tue, 15 Feb 2022 04:17:05 -0500
X-MC-Unique: gcRW4c0pMlCUgZHUHMbomg-1
Received: by mail-pf1-f199.google.com with SMTP id g19-20020aa796b3000000b004e136dcec34so2778647pfk.23
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 01:17:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VnPiU1Qy3yqpU/b3Z9r+xuf1edGX1aazobnu8piUvc0=;
        b=Rj5qkVkkYLL/So/ytWmA/M6Z6y7DQXPDDifbnNkmVwJFRfQELpyhPUSaf1n9NmBC67
         lLKe7LJPLIJowVRqGBc133XtpGQDicjIQbEicfz1EnQqcDooDzcJqldUSMUxc8km/pzk
         Ls0P3WPde3hkQXjf48X7hxwgSPe6sSp4M87WXrJY5w/vhMfAnX734fdv/6kNWJqDCUnO
         +3LB4ow332LmEEBlX/Tiy62ukWaYYyFi4DTiOGlM/44zbVlSM7XIwEO6zRKTM4WsRHyl
         nP7daCqkImCZtQ1VCan0yIhWUqvm309xjZRM1w+7dOv0Mw4aCLpcw4jcP/5zESvvc6NE
         6BQA==
X-Gm-Message-State: AOAM53391A0T6d7Gq67W5W+Y4N5oELqhITLx75s7OAkqIBts+VTyDVDk
        SLvO7fhN2FF343MBNLmCSZOuwMpEXJ6hbWKS7rf6/v/mNAePOhtmBZ1smMp1g1PCghtCYVtwM6v
        abY4TFB0PfHbrc9G/2G5YYQ==
X-Received: by 2002:a17:903:2309:: with SMTP id d9mr3210178plh.74.1644916624205;
        Tue, 15 Feb 2022 01:17:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0IkdLuek2i0js6E3BcnboabCk8ZyzRxxirU5d0L26PU79Bcwsbv+V7EvDk/mbisRT8ptlHA==
X-Received: by 2002:a17:903:2309:: with SMTP id d9mr3210153plh.74.1644916623931;
        Tue, 15 Feb 2022 01:17:03 -0800 (PST)
Received: from h3ckers-pride.redhat.com ([124.123.80.180])
        by smtp.gmail.com with ESMTPSA id kk14sm16569550pjb.26.2022.02.15.01.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 01:17:03 -0800 (PST)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 0/3] ceph: forward average read/write/metadata latency
Date:   Tue, 15 Feb 2022 14:46:54 +0530
Message-Id: <20220215091657.104079-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

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

Venky Shankar (3):
  ceph: track average r/w/m latency
  ceph: include average/stdev r/w/m latency in mds metrics
  ceph: use tracked average r/w/m latencies to display metrics in
    debugfs

 fs/ceph/debugfs.c |  2 +-
 fs/ceph/metric.c  | 44 +++++++++++++++++++++++----------------
 fs/ceph/metric.h  | 52 +++++++++++++++++++++++++++++++++--------------
 3 files changed, 65 insertions(+), 33 deletions(-)

-- 
2.27.0

