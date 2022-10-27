Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAB260F8D4
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 15:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbiJ0NP5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Oct 2022 09:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbiJ0NPz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Oct 2022 09:15:55 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D225855B7
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 06:15:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l6so1526040pjj.0
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 06:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBfCM5SMkIGMEbZoL8e3ReYcZIOMaiwrs47mnFIdDdk=;
        b=uK6WYYH1RMGUmm6jYgWDrdeLhvUL5CH1VnIPTfz1BR/vxfvHv/j0SD1F/CeSgx7ZhP
         oyO64Cpp8AkqyePXjFn0jEG6G5I07KGHwdIAQpANtIuZqKRKZahIZ7Gj4bRYDXsnFNxS
         cM4yJVrQVedCrg0oUPRYroCoi9UdBq+xIbe+kUH4UnPHd9mAvQ0yQ+aH+LezUSEGKHGp
         H3Vz8Ra5tAZjw4djtX0N2kI/A2hFaWDaQ+n53hWO0kFkGWNcZqnuCz/4hngQpylTpN/T
         izkk9LQsklOjleQ4JJk4gEC31AnWioZ8OkdG4fW8nFq1hSjNDtTps7198jm2RKoRkAl+
         TvQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TBfCM5SMkIGMEbZoL8e3ReYcZIOMaiwrs47mnFIdDdk=;
        b=ko749wAqT8CN7A+wYM0g+i6CbY7ju5WNK1CWgLtezsNdEEUbpa6v1TUsydRBHO7yy+
         DE5ZBegz8ttHKGGd8u+Dbs8wKg+E6dXNDbLAtX4KpRrwdheR1QHq8nsUeugWoGALHbBw
         A3Od2/OHUMMxoejL87Ui9txd2GuF/rvobeJUR2lIp5roQlqqLB7ZYLTnQ6whTuy/rGOQ
         8cTJxXepLnznzJ7pZNAmtueIM5WJUiurzLGdpdyQb5aja2XDB6Dy214et/Tg6r6YL7pR
         LUYk5imiypors2+HQIFAV/5QqOjeAHU8Ti3O6y3lnzZDVNDdVy+x7LVLo1Cd2zJ5CrOh
         LHdA==
X-Gm-Message-State: ACrzQf0WGQRDMvFL9ThwkgFZKk9p93H+2WmIMle5XbQF3k5dDzb+V6w4
        rp2X3m7MzZbXMtVGXvpRMeHTFhnSrJibh3cP
X-Google-Smtp-Source: AMsMyM6fdsnMZ1IafarP5oLU+jn2wyrHokSsVLtd1NjIjMvXU3imwtSkb3N44hUr0gZG6KKEKjRXlg==
X-Received: by 2002:a17:902:c189:b0:186:88bd:42c4 with SMTP id d9-20020a170902c18900b0018688bd42c4mr29140566pld.0.1666876553518;
        Thu, 27 Oct 2022 06:15:53 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m10-20020a63f60a000000b004608b721dfesm1027480pgh.38.2022.10.27.06.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 06:15:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ceph-devel@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>,
        linux-block@vger.kernel.org
Cc:     yehuda@hq.newdream.net, idryomov@gmail.com,
        dongsheng.yang@easystack.cn
In-Reply-To: <20221027091918.2294132-1-yangyingliang@huawei.com>
References: <20221027091918.2294132-1-yangyingliang@huawei.com>
Subject: Re: [PATCH] rbd: fix possible memory leak in rbd_sysfs_init()
Message-Id: <166687655254.10763.17976246542549193136.b4-ty@kernel.dk>
Date:   Thu, 27 Oct 2022 07:15:52 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 27 Oct 2022 17:19:18 +0800, Yang Yingliang wrote:
> If device_register() returns error in rbd_sysfs_init(), name of kobject
> which is allocated in dev_set_name() called in device_add() is leaked.
> 
> As comment of device_add() says, it should call put_device() to drop
> the reference count that was set in device_initialize() when it fails,
> so the name can be freed in kobject_cleanup().
> 
> [...]

Applied, thanks!

[1/1] rbd: fix possible memory leak in rbd_sysfs_init()
      (no commit info)

Best regards,
-- 
Jens Axboe


