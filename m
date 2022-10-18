Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7E560212C
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Oct 2022 04:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiJRC3d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Oct 2022 22:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiJRC3a (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Oct 2022 22:29:30 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB01911A2D
        for <ceph-devel@vger.kernel.org>; Mon, 17 Oct 2022 19:29:27 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id x20so5053879ual.6
        for <ceph-devel@vger.kernel.org>; Mon, 17 Oct 2022 19:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=icaUfnRmqqgAfOyB5UA3L5AWlu3VGMimvDWPBcXOwbA=;
        b=juXHXuNO+X0Wu2M9Dq0nftUcQSnM/T1vJ5FY6AWI3wGunDWs82w8xOJZvodYFBEbAT
         wv2CuU0RYuHZt76QtUwLVIvrhz9EYfv2sKm1t6GZcLK4KFakDAPQA5m8weflz7zZ/c/Z
         bHVFLl2fvrAzUEIz0ci9Fi1++E72KQj7qqsMHci5kCgvePjZvrNb52kQbnKGw5EvZSsO
         4h2yjVa6hLxuqCCYvoVXOIlTkzU0KccE5IcauGsF1JaIl8FeVnXswL9XhwX1eX0IN+YC
         Gd/pq89VNUa7Npw97EtZZzuYo2Xy6c7SrQHazUzq3Wa4ipxcOKb05dcp1eGTeO9OxoKG
         xcyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=icaUfnRmqqgAfOyB5UA3L5AWlu3VGMimvDWPBcXOwbA=;
        b=T1R+1F+A6LlnO7P4uNAkwYp+Dw++1c8p/13tBX1Aa96XgteJyc06KHqo3ZiP4cEYZd
         x4/QvnKTQyGXKwL+DIM7RD8zSyQrwBSaT0h5l9crbeIZSmC8ODs5hjQ3qzduXWzretZF
         W3GBdZFDcRb5idM+sbJE6c0QLqWRr90IrnjwHZTXIoYb399u24sReEC/TsY7c/vfShWW
         ve3sQneCpV10RGvzCGtydLpR8vhRcdODsjPR+nSq/l3VmlQxbez62psuZhzR+CXz6bcb
         sZQ/xSvuC5+rxwfQjQxEOC6Xvv+kJVkL6J+JbiHEBkelX9MHLZCgAwzx8BrOjpnj6iPC
         xtdw==
X-Gm-Message-State: ACrzQf0zHnRQrgmZS8jf8hFMumvp+EL+5ZFSt8UPPo5t6qFBu95AVoqR
        0+zWXC3giN3kzV8+0IeC0wUgPI1kjdH8rYLMMVb/X96kvJE=
X-Google-Smtp-Source: AMsMyM5LHqH2QLmXQi1sXVb5HM9FnWZtEuvxLxL55Lv4P92ppbFqcamavbFiOKGS3VzGNZyX+Kqvd3+JlCf/8aKs7Cg=
X-Received: by 2002:ab0:15ed:0:b0:365:f250:7384 with SMTP id
 j42-20020ab015ed000000b00365f2507384mr414861uae.44.1666060165823; Mon, 17 Oct
 2022 19:29:25 -0700 (PDT)
MIME-Version: 1.0
From:   Satoru Takeuchi <satoru.takeuchi@gmail.com>
Date:   Tue, 18 Oct 2022 11:29:22 +0900
Message-ID: <CAMym5wsABmduNp=JvwutFioiq24Qtm=fniKDDxqatFhpk_teYQ@mail.gmail.com>
Subject: Is downburst still maintained?
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

I've tried to run teuthology in my local environment by following the
official docs.
FIrst I tried to use downburst but I found that it hasn't updated for
a long time.

https://github.com/ceph/downburst

Is downburst still maintained? Currently, I prepare my nodes by
Vagrant and would
like to know whether my approach is correct or not.

Thanks,
Satoru
