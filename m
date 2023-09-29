Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77EE87B3A81
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Sep 2023 21:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjI2TSG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 Sep 2023 15:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbjI2TSD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 Sep 2023 15:18:03 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB4CCD2
        for <ceph-devel@vger.kernel.org>; Fri, 29 Sep 2023 12:17:50 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c364fb8a4cso130962685ad.1
        for <ceph-devel@vger.kernel.org>; Fri, 29 Sep 2023 12:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696015069; x=1696619869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O9Agy5s4S8M1IK3kKW72b7BGJqP7wh82OnywEz1kIDU=;
        b=YCkq46jRGmImCAivsYasdO1yZRpq8MBFpCPMcS8448SaK56i/1rbbNnaoHUe6QghrG
         vdXi130cFuZODB44qWLxoIz3PZ12jUQRl6TsqdO/Tld+Sl8gSZ3FXjGBc4f3uep82zHs
         p1WO0hhsHgctz4uhJNcS3aPi/tXmloOjtMM7M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696015069; x=1696619869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O9Agy5s4S8M1IK3kKW72b7BGJqP7wh82OnywEz1kIDU=;
        b=PNURPuRM9ZIxVGW0BhUUlTBiDIORWvv48njYnHIJr3Jl+4o4Zkfchw6ezf3u5du64Q
         A7LgEC/kiBQ7ZayxwBK3ukOSAgeXHZB+1z45MeDd0vJIfJ5YVRE5ttuZUyEm/pfFzxEI
         g859kEW+XoHVXD6IkZBtOnFkcDv7IKNC5s1gG2bztNmKaHWbk29NgmpQPLTA8vPpmNT6
         GXzBV565mkXC4z0hvr5Fv4NAUKkNtKDBhBZxckiWnCUeXkYiUx00ebCz5qbZDAXNh5zJ
         5aZEjqDRSfB/xJBHWDS5QQmd084et/UGF2N/xx0BEcl3xZv169r/qIMSXKzadqTvMWiq
         65Ow==
X-Gm-Message-State: AOJu0Yypz2MFUzVp9nP59pn9VeilRZmLAVhb1Zwd/GCDKBM8JQkZgzYT
        Ay5bJt4rD7ZSZqIXeh2z6ash8Q==
X-Google-Smtp-Source: AGHT+IEVDhX/ETUEQbx2moy+5lx2QtId+M6PvXVx/7NtlV7iSWepfhzKC/QMvckGkhEfvGTPuEjidw==
X-Received: by 2002:a17:903:1247:b0:1c4:3cd5:4298 with SMTP id u7-20020a170903124700b001c43cd54298mr5884998plh.18.1696015069590;
        Fri, 29 Sep 2023 12:17:49 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id q3-20020a170902dac300b001b9c5e07bc3sm17326434plx.238.2023.09.29.12.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Sep 2023 12:17:48 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Kees Cook <keescook@chromium.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] ceph: Annotate struct ceph_osd_request with __counted_by
Date:   Fri, 29 Sep 2023 12:17:45 -0700
Message-Id: <169601506494.3012633.9364328079132196540.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230915201517.never.373-kees@kernel.org>
References: <20230915201517.never.373-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 15 Sep 2023 13:15:17 -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct ceph_osd_request.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] ceph: Annotate struct ceph_osd_request with __counted_by
      https://git.kernel.org/kees/c/b25373dde858

Take care,

-- 
Kees Cook

