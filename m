Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D86B7C4F65
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Oct 2023 11:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbjJKJuq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Oct 2023 05:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjJKJul (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Oct 2023 05:50:41 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7918C4
        for <ceph-devel@vger.kernel.org>; Wed, 11 Oct 2023 02:50:39 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-406618d0992so63883525e9.0
        for <ceph-devel@vger.kernel.org>; Wed, 11 Oct 2023 02:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697017838; x=1697622638; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tmQO9vCbLRBEKuzIIdziPoF50PIw+y6A20pY+tXcXbg=;
        b=DCYW3DbbQDJEZMiPuzl0YEZuiA/1ZLHP3R5zsWPdr538qyDDHO+0FeK7GTdPFwssPP
         hX2XdvdHhRuq/t2Hu+ezHvOr80nf2exxtsJNK85/wUjg2nUZ9ReOQ4ypVeZeng4Tq0KA
         5IS05aEr2pqPbKV0skst+T2ByZ+OZwzqodStRMCUR2gMWJpV7zHBCmfGASrSlQ9JcYw/
         4BFYsb5s0Hgqv7vBsq1zG71GMJvkEmy1yesffKSAYi08Rsln9kVPbW+on+CI4f+n/l4/
         /e6qd7gMhqNZuLI5/CuCzpH8huzeLjyFjkXxXaQboZTkb+muuLW2I4TDCP+YXMbretnr
         C9HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697017838; x=1697622638;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tmQO9vCbLRBEKuzIIdziPoF50PIw+y6A20pY+tXcXbg=;
        b=R8XdU99bPrOeRIHL9gujgKCVSwIa8MMJi0lmdHaB8QHGwCHmY4hfZTUolxyT3iEcfd
         Li2l3vzLkxwHN9WEnCwhSk62kqEaz/WlqDF9AX1SpkCtnxdRrtsWzsyawCRfs+qq5Tiz
         WReqHtUet4d92z+uci9jisEPg4O3Eo3In85k6RKHLk5JCHyL+CFHr3pkjTQXOWfcHLq0
         1yB0GSfzw9r+ABu4M9TLGgj0XNECG36PWsvXUodiNv7lsSvIfh54nCCsKz9nt47H0Mup
         ri4GUT9p+vIRaBdeA+iRc0n/BCVTDIJxrokCMAERFDfQ0qE1+llvOFlnd+oi+gAta5pv
         0VuQ==
X-Gm-Message-State: AOJu0YxDMrb9PRF3QCIeCOwlxbaPAD8k+Rv7brjG2LTnUa6cigZqk1Jn
        js8IQv3NXs56QTULI55WBPn6roYdjyB5lGJifpw=
X-Google-Smtp-Source: AGHT+IFtJcZRG8RK5IH36aStvdAJuy/cYhxIT6HuX6MfTEcSpWKQ0kUhgfQTR/F9ZZnxUVXwlAREwg==
X-Received: by 2002:a7b:c40a:0:b0:406:61c6:30b8 with SMTP id k10-20020a7bc40a000000b0040661c630b8mr17763877wmi.22.1697017838258;
        Wed, 11 Oct 2023 02:50:38 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id p15-20020a7bcc8f000000b003fee6e170f9sm16379462wma.45.2023.10.11.02.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 02:50:37 -0700 (PDT)
Date:   Wed, 11 Oct 2023 12:50:34 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org
Subject: [bug report] libceph: add new iov_iter-based ceph_msg_data_type and
 ceph_osd_data_type
Message-ID: <c5a75561-b6c7-4217-9e70-4b3212fd05f8@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello Jeff Layton,

To be honest, I'm not sure why I am only seeing this now.  These
warnings are hard to analyse because they involve such a long call tree.
Anyway, hopefully it's not too complicated for you since you know the
code.

The patch dee0c5f83460: "libceph: add new iov_iter-based
ceph_msg_data_type and ceph_osd_data_type" from Jul 1, 2022
(linux-next), leads to the following Smatch static checker warning:

	lib/iov_iter.c:905 want_pages_array()
	warn: sleeping in atomic context

lib/iov_iter.c
    896 static int want_pages_array(struct page ***res, size_t size,
    897                             size_t start, unsigned int maxpages)
    898 {
    899         unsigned int count = DIV_ROUND_UP(size + start, PAGE_SIZE);
    900 
    901         if (count > maxpages)
    902                 count = maxpages;
    903         WARN_ON(!count);        // caller should've prevented that
    904         if (!*res) {
--> 905                 *res = kvmalloc_array(count, sizeof(struct page *), GFP_KERNEL);
    906                 if (!*res)
    907                         return 0;
    908         }
    909         return count;
    910 }


prep_next_sparse_read() <- disables preempt
-> advance_cursor()
   -> ceph_msg_data_next()
      -> ceph_msg_data_iter_next()
         -> iov_iter_get_pages2()
            -> __iov_iter_get_pages_alloc()
               -> want_pages_array()

The prep_next_sparse_read() functions hold the spin_lock(&o->o_requests_lock);
lock so it can't sleep.  But iov_iter_get_pages2() seems like a sleeping
operation.

regards,
dan carpenter
