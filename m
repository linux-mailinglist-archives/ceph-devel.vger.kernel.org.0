Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E4D5F853A
	for <lists+ceph-devel@lfdr.de>; Sat,  8 Oct 2022 14:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiJHMjR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 8 Oct 2022 08:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJHMjQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 8 Oct 2022 08:39:16 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705CF45060
        for <ceph-devel@vger.kernel.org>; Sat,  8 Oct 2022 05:39:15 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id w139so3374793vkw.7
        for <ceph-devel@vger.kernel.org>; Sat, 08 Oct 2022 05:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g5Fz+k2oS5BcZ3WsKchoO/qh9KtksgCZbHF4o5tVxQQ=;
        b=CDxKwHvagZ1RmLy3tSfL51Pfp4jt58MWUcHwnayqmrnBONFPg6G4yFbu1IMLGoTrMD
         0pGxvG2gEHyZu7axvEhosyHz/EXO70hxA4d5iBU6ZVvE1PoIJoSYgRI6M1FAkstunCwl
         j3uNx4xZd1QfzsIvLaeQU5mvFC3LSlmFgulsjUye7vo4NLfHcSSzG2AKbJxaeBZnet43
         itJYi1p9I86OlNzOJk1KxrwLtx7SxuqbgIikF6MsXF5q1EB0vcRDadaJ46ImBlSDJq7G
         AjABfbphTUZcForxyIkuFte6mqyXHPAZ+2W/uPTIL/O04q1F+zmBsEqp1aSz8CZBgk4n
         l6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g5Fz+k2oS5BcZ3WsKchoO/qh9KtksgCZbHF4o5tVxQQ=;
        b=QCvsTFeGuj+ldhnu+AYfu65PukfzflzZlv4s0cqDa/B9MD2bjUDM5vGkbL0eTJmEDw
         H87AY378WmhPH++pPMoe0lUxeIIUy2/4gQt8vx19ka8IEuvWxNiZA85SPQCO/6nA3PUX
         qxivVaKiJY3RwBwg2siXqbdZrZmhk1+lggHVGIJjrMoZDrykIoXM2Uiw/7c5n79F8O9R
         id+PD59ObzUKWFd9GtOsKXYXZk3YJrnjKbPVq43iZ853t2G60Osl2bZzXQe1L9F8n9Pm
         67C4pzkKWAQ9rCP6X7jFvZQgBn5/8DQs2vSmLy7hbwvJlfMytqVdFmn9Rm95rigmqD9o
         xnOA==
X-Gm-Message-State: ACrzQf3nn9KOpBgBl8n8MQLcUS5cAM8bwb4YDCXZfNzjC6AXXzVv014b
        9nHEKmY+4uqo1NyUk9ViKfHTrI9tXvWPzbHIhM8=
X-Google-Smtp-Source: AMsMyM538zodIgTHUcSrpDnY/ZDX1hPQNQBZDK8+GgG5cG+RcTICowqgO/11NjjcOwbRXhqnzojzYd5XNj/1FHtRiKw=
X-Received: by 2002:a1f:9bd7:0:b0:3a3:a3c3:68f7 with SMTP id
 d206-20020a1f9bd7000000b003a3a3c368f7mr5323985vke.0.1665232753990; Sat, 08
 Oct 2022 05:39:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:1a1c:0:b0:310:4513:38c4 with HTTP; Sat, 8 Oct 2022
 05:39:13 -0700 (PDT)
From:   Sverdropoil <benjaminakonde85@gmail.com>
Date:   Sat, 8 Oct 2022 12:39:13 +0000
Message-ID: <CABWbvVDfrWh1ZQHqcNrbxdXrDNcFPtGvYuv3nH73WbCK1WTe0A@mail.gmail.com>
Subject: Hi
To:     earnestbillie91@yahoo.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Please is this email valid?

Mr. Earnest Billie, from USA
