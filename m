Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A0E6FA0DD
	for <lists+ceph-devel@lfdr.de>; Mon,  8 May 2023 09:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbjEHHUM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 May 2023 03:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbjEHHUK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 May 2023 03:20:10 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC62420C
        for <ceph-devel@vger.kernel.org>; Mon,  8 May 2023 00:20:09 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f41d087b24so10120425e9.1
        for <ceph-devel@vger.kernel.org>; Mon, 08 May 2023 00:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683530407; x=1686122407;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c4qm2kkFPXz3iMSaYWzsWVc+tB/w60qM5yghYXF0h/0=;
        b=nsF9aVsijncPE+t+hLMawCqEjVXfmoX/hewa8CUd63NcXN39Y4rdtD8x2/WbkXCIQ2
         l7folrWOcmK1QpB3JhT+5XlalATtvfJEAmdV07BX7wmRsHRP81zk86Fy7pOlzr+nONp7
         fMpYG8AfLNmVaR1Y00f17Q/HSAPF4GwMawfWBJLqewbiX/6rgeUBeuUMzVtI4i83/OQb
         dVqKYfTR45mS/kQut1gLdRnUb2h+AT+j7oVFrY71aT7nhIh42+xYu4sYFqblWKze8JEV
         LiMvDX2/uCKuZCmk4WkWf8Plqcygtxqa6AA1wR650N3KWsxLF6gdozLfzVoFaHjQ8cUR
         o37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683530407; x=1686122407;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c4qm2kkFPXz3iMSaYWzsWVc+tB/w60qM5yghYXF0h/0=;
        b=lmKIRJnHmc+niaODtO56iHFymWxGjmni4a8jC6T6bzd8Pn6eUwcS3jmoGCwQcotw9u
         RA/NM03G4NLXGy8JkuysyVNtISXYoABOLCtyLtNwawg/lL/qRs+rEAzWWUtmmAEQTVEu
         A1nsPaRgJduCDiWDzrv5RmkG1GJE0MBYawTjmY9u081udukKhBw1rgb+BN7OrsU6u01x
         TK6PC4YCiJ596vuHPGFBvBUS0kEjFh++apgFmk5tRFBe96zFgs/LTjwVafZvnCJxzCa8
         wco+Fm65t2v3g9wTr1/KIwJC1+L+l7CZL+tXNvKZA//h7ruN5W7VMkad4jawejlACv0n
         C9MQ==
X-Gm-Message-State: AC+VfDwBGR/P1AZTjgRXmAh/t9agAcMn/DIvbuLjkjrQvv//zIXjOVyA
        dlK0Xe5FgrQ8nJx1DUoF8nE4fQ==
X-Google-Smtp-Source: ACHHUZ7WTBlORjwkJt26PTeAlkR7lXtaXVNu3cHYCYU3i3qcQh5kXX6930OWBGXYthJwDm/hOStRvA==
X-Received: by 2002:adf:f291:0:b0:306:3bf0:f1ec with SMTP id k17-20020adff291000000b003063bf0f1ecmr6922529wro.7.1683530407529;
        Mon, 08 May 2023 00:20:07 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id f16-20020a5d4dd0000000b003062ad45243sm10363523wru.14.2023.05.08.00.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 00:20:05 -0700 (PDT)
Date:   Mon, 8 May 2023 10:20:02 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ceph: fix the Smatch static checker warning in
 reconnect_caps_cb()
Message-ID: <83208f55-7c60-48a1-bbe2-5973e1f46a09@kili.mountain>
References: <20230508065335.114409-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508065335.114409-1-xiubli@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, May 08, 2023 at 02:53:35PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Smatch static checker warning:
> 
>   fs/ceph/mds_client.c:3968 reconnect_caps_cb()
>   warn: missing error code here? '__get_cap_for_mds()' failed. 'err' = '0'
> 
> Cc: stable@vger.kernel.org
> Fixes: aaf67de78807 ("ceph: fix potential use-after-free bug when trimming caps")

Of course, thanks for the patch. But this is not really a bug fix since
it doesn't change runtime at all.  And definitely no need to CC stable.

regards,
dan carpenter

