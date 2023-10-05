Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A5F7BA2AC
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Oct 2023 17:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbjJEPpV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Oct 2023 11:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbjJEPo4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Oct 2023 11:44:56 -0400
Received: from mail-oa1-x48.google.com (mail-oa1-x48.google.com [IPv6:2001:4860:4864:20::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDA4EA
        for <ceph-devel@vger.kernel.org>; Thu,  5 Oct 2023 07:31:07 -0700 (PDT)
Received: by mail-oa1-x48.google.com with SMTP id 586e51a60fabf-1dcdffddde7so1420149fac.0
        for <ceph-devel@vger.kernel.org>; Thu, 05 Oct 2023 07:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696516266; x=1697121066; darn=vger.kernel.org;
        h=to:from:subject:date:message-id:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r78orqn0mclCwquTfLvqBbt3i/cIuzkxAisQtEHTMAM=;
        b=JjGNsJ6rIegRrdn9wgF7VPVFQW3obe7Gw94U/FHjqd8c6JxRy/XWH5ZlXL+bTCJQMt
         JZvJK3kyjgbM/NuZ5+fWblR3ujo5tXZljGx5kUkwW9hrhGiiFa3Q1OjvtwAg9j4ev1O/
         Ds1ghESMblMiKL+I9J0FeEPhGoFKcYWXbyY5auUxx9T+GB/AFe8gqDJB87RBZxKQvhaZ
         lVEx1hzE3bz8UbFL8OK12nISyZXGL6JgTQex4Nc/FD0UVh7UyKIdqnxeA9u6bbMVBgjd
         3rnMsTr3h586lnJPOGavrTRCHDSc3nFc3W4AAwusMJAY1g0BC/8u97Lb8pqkJ814SwyP
         jckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696516266; x=1697121066;
        h=to:from:subject:date:message-id:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r78orqn0mclCwquTfLvqBbt3i/cIuzkxAisQtEHTMAM=;
        b=YjXKJKSXZTKiTOX3gz5rBEaSIUpDudiw7mIfJtLGafFeebNi1IWPAY9sbnMYS8gSJV
         le6aK+AtdXyrn5uRAKRvrA+XaU6wmv84kPpy9y4kS4b5mMESxiMrOXZPqSZ8pWdmpM0c
         LomGigE35fwvj7gX8QKSAED01tAaYGNRztZC1Q1hb8mwR+7LlbNCUZF9pzRmxiLNbLX4
         fEJHYaeOJZrrEad+WvWOpbcxgrsS+aMiSvgRM1BZN5wJ4HAxYmhP4MGl1/8+6HlGYWEz
         RFZ1p4hWy8q07wFWiER5CRwnoL2nnsb2IeB6zaTdxz4DWWpAguN7xRateUkDLioIlFG4
         cP8Q==
X-Gm-Message-State: AOJu0YxS9u7Bld3IEWaviTl6AMRdlb0Rp3sNUylPe6kgya+LFtArpNLz
        S57IQh1Z+dGEfg2S33ebPNolkoSCP7o6
X-Google-Smtp-Source: AGHT+IHf6Uuf1jB9jNtoMR/FzyZJXeZ1rHFlut40rBaVP7pCg59aTHX69vOkmQb6jTZ8zPxU51Q9XYPwmA==
MIME-Version: 1.0
X-Received: by 2002:a05:6870:5b0e:b0:1d6:5eee:ce8a with SMTP id
 ds14-20020a0568705b0e00b001d65eeece8amr1943137oab.4.1696516266526; Thu, 05
 Oct 2023 07:31:06 -0700 (PDT)
Message-ID: <autogen-java-5b4de35c-3d1a-4226-a096-096a1751211d@google.com>
Date:   Thu, 05 Oct 2023 14:31:06 +0000
Subject: Garment Manufacturing & Export House
From:   hartirysdar@gmail.com
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
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
I hope all is well. My name is Hartiry. I am working in a Silk Style Pvt.  
Ltd. A garment manufacturing and export house.
Our organization is strategically based in Noida, India, an Export-oriented  
Industrial centre with all requisite facilities.

We deliver high quality product at highly competitive price. Because of our  
quality, timely delivery and competitive price, we are able to meet the  
increasing demands of our valued clients.


We would be happy to explore the business opportunities with you, if you  
are looking for any manufacturing and export house.

I will be happy to share company profile and previous work portfolio.

Looking forward hearing from you.


Cheers!
Hartiry
Sr. Business Development executive
Silk Style Pvt. Ltd

