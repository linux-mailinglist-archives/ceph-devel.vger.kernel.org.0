Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E8A63B82E
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Nov 2022 03:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbiK2Csq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Nov 2022 21:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbiK2Csp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 28 Nov 2022 21:48:45 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484E13F061
        for <ceph-devel@vger.kernel.org>; Mon, 28 Nov 2022 18:48:45 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id l127so13794196oia.8
        for <ceph-devel@vger.kernel.org>; Mon, 28 Nov 2022 18:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pmGd0PgdIY17QLC7b/Cb5BiagQdM8bBANSaemwvEIh0=;
        b=nWObwBMQiqzhCea8Bpg4UFIZQy3QEAIyEpKZx1gBqBN1Mjjecb38wlEwWtSvtRu4ZK
         wHw2xSnSXX2AAw9rOUgzX6WdySB7phhmfecoTEAyT/7Y7H77KMI6AcqM07eYt+IO036u
         kbTR5g6D17TRUj2cIPWlWhoRYF2R0+RdXUcSkmrnsqieBYogkr310jFeS47+lkorp7Ae
         usE26r1P620XZLgycuwyH1DuQFnWdCd0YbqhJspEdgbg4Jxn+xVfBMNnbxYpAjeZgTaW
         Joppjbhr32rSWlHxDirtAjLuPElRj95FiaXXDm347jVMado9VZX8O25o9qVrHwnlzB+H
         Pwrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pmGd0PgdIY17QLC7b/Cb5BiagQdM8bBANSaemwvEIh0=;
        b=YpAWGZCb2Y4HMZzxAHdLnS5LSjAnGi63NjsxlJlVUVM0jUse7ZQ9u+bvXojicS3RCB
         ljFtw4HiQEUo+DEvecdLsni3pNr4qMXneNtCOUftjHX4P0W1h2+XrDvFS/JzN/QFUPbY
         PmNu5B0ri0MKdXqFeysfF9RWog4dMgY0G7BU86+eC/I5hBW5aqGOQjo3ObUkpaMO5J7j
         Sk1fNcScFdrAi4fwB6ouglUVzqHaFCO369mgNRyc/11Uql7MTNY7CEvumjzZfJEBE2ft
         20v5m3/DDeig9FgLOrdrjdYuvdXX8rEkfLOxLpGuLvlvMf5gQe1M2W9XB4BMie7d/sh8
         yfcg==
X-Gm-Message-State: ANoB5pmeu0Bn7R3Q1UUMdZ4kYyn65dH9c4KT0eUdZRksZSQous3Tnn48
        w4BWAJ2Ag6A46NvA/59LZUMR1GZVPMSR6HJcRHKB6miN
X-Google-Smtp-Source: AA0mqf5nFRCMQjMcM/7Iyu7iE82oU1xCuwXnaF7kT6e8LG1p1ByTNb8ytEY49LFWKnDXyg9yCGOOGrrhXwD1Q3lemm8=
X-Received: by 2002:a54:4596:0:b0:359:fea2:69d0 with SMTP id
 z22-20020a544596000000b00359fea269d0mr15940291oib.45.1669690124416; Mon, 28
 Nov 2022 18:48:44 -0800 (PST)
MIME-Version: 1.0
From:   Satoru Takeuchi <satoru.takeuchi@gmail.com>
Date:   Tue, 29 Nov 2022 11:48:37 +0900
Message-ID: <CAMym5wv3pxf09OMOFn8ZcCJL=gi0dstaeTTLCngghVvqb7-zPw@mail.gmail.com>
Subject: Does the official QA process use HDD for OSD?
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

I shared my knowledge about the bugs which my team encountered and two
proposals to improve the official QA process in Ceph Virtual.

https://www.youtube.com/watch?v=ENvDbgX4n38
https://speakerdeck.com/sat/revealing-bluestore-corruption-bugs-in-containerized-ceph-clusters

One of my proposals depends on the assumption that the official QA
doesn't use HDD.
It's because my team revealed many bugs in OSD creation/restart only
in HDD-based clusters.
Could you tell me whether my assumption is correct or not?

Thanks,
Satoru
