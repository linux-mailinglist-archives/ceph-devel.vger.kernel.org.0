Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099086E53B6
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 23:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjDQVMv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Apr 2023 17:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDQVMu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Apr 2023 17:12:50 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E7244B7
        for <ceph-devel@vger.kernel.org>; Mon, 17 Apr 2023 14:12:49 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-187f76c50dbso3416084fac.10
        for <ceph-devel@vger.kernel.org>; Mon, 17 Apr 2023 14:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681765969; x=1684357969;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4jlL8pzL6NVZbuVjV4h5KPilkuQmPMJRpXcDIhZ2tX0=;
        b=aXvtdxosdP+JIqs1K10Jcg3j8/Rza6xauKjTHD84za4EaN3hlGU+B4PH44fowspNBH
         A/jcQNLsox2ve9F3Y/UDa6xGZ7kKulmRCSJ9k+FoIUGaEBaXcOCb+AKC/zT8tHnEUyA5
         6djt+40r6ugBzzxYz4QRkPvUffS7+fYfrUGeV9gf9mwgCtuLbn9qaT6AgRZcezBSoHk1
         LEn4SfxBHzke0bz+UWkA5ZOeYnluXGfIB1bMXZ8pa6UZO0xgfJ7hx+ekkFcWddsfuH37
         4yym3X1hS+4FYNBA6hn/4S0NuKakJQAWXOmlI5TYJXQmnipWD6TYTYpdKk2qdUs10Ec9
         e/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681765969; x=1684357969;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4jlL8pzL6NVZbuVjV4h5KPilkuQmPMJRpXcDIhZ2tX0=;
        b=iIw6WGuQQ8OpCJcbKVaojZkka2ret8oqr2SItNxjWYyJ8u1F2cfESq91Foau8kKSrb
         Woze8bYTjhhVuUR4W/Bz3ZkGiS7cok7P/8zhMKgEd4Nm6VyeuW6QjAqs4WpNcx3brN9Z
         R50D6AbWyc7T0Zw3oBD7EZrml4RmUq+qXstFmf6obTqmCfGUMxn46VENUDZUuE64Bxgm
         MsCcXGHCKcDSQ/y8y09WhRojRFTY2V6hOeFnB3mIxRDq2JpPmtlH1unu8NQ4SKYkqYyp
         tl8BXmIn/QO0WE0E8OvVdbPXvZJ7fRJ/EASC7Z8xT9rCr/AqTiP2YWkD2mMnXNsO087f
         /viw==
X-Gm-Message-State: AAQBX9cr/86apqAmsusc7XyYWMgbSQSR35v496CR+UoViK7vKBoSw7Jf
        31R8pvns+caWsg3dPB/62q6F1Ky/euxYmmJO0WU=
X-Google-Smtp-Source: AKy350aKFEB0bpMImSkRQfRo1U1wNDWil81aHlDq91ccPR1PwslqBYcG0mnvKnvupRX7OS1y+bGDP5Q0y9L78XImMcg=
X-Received: by 2002:a05:6870:e99b:b0:186:d9e3:e279 with SMTP id
 r27-20020a056870e99b00b00186d9e3e279mr6198925oao.5.1681765968789; Mon, 17 Apr
 2023 14:12:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:53a3:b0:eb:2716:3f1d with HTTP; Mon, 17 Apr 2023
 14:12:48 -0700 (PDT)
Reply-To: ninacoulibaly03@myself.com
From:   Nina Coulibaly <regionalmanager.nina@gmail.com>
Date:   Mon, 17 Apr 2023 14:12:48 -0700
Message-ID: <CAHTAA8poyBPBR8=2hGwJCtYMhdaW5FOHPzZpYXuf6qTRwmNJhg@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear,

Please grant me permission to share a very crucial discussion with
you.I am looking forward to hearing from you at your earliest
convenience.

Mrs. Nina Coulibaly
