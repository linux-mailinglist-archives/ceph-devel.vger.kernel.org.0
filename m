Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3F21BF99
	for <lists+ceph-devel@lfdr.de>; Tue, 14 May 2019 00:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfEMWrM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 May 2019 18:47:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41067 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfEMWrM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 May 2019 18:47:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id d12so16985017wrm.8
        for <ceph-devel@vger.kernel.org>; Mon, 13 May 2019 15:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8NwNULtWwx5Pb38bN7drUkQb+DIEmPFqpFPgTOk+Y5o=;
        b=UoICGRVQhswOm1w0iBq2Dfnoa/DuU5x0oxvr4b9rlhFV4602wc987vTNuAOIMD4cGN
         orAe6wjXnlnfvmZBTV5AA6aVHi+O6TtxHJr3Kx4AWhv7Jnpdm7sa+z8ehEpcK8qLFPCD
         ND8kzfU1vYDNxwdVwUj9akBh7LErIPmKopZWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8NwNULtWwx5Pb38bN7drUkQb+DIEmPFqpFPgTOk+Y5o=;
        b=Sxrz2EZWaKUlCODRlgtn2eBxjRD8DvdPY7VeN/SMB8Ajs0JoeUwKXBCvWmLXr75V67
         l3iS2hzlcOb9oDs0ao7FrtWHSD0xP1NIKfsO/Kd+qLJpDu5Ig2B9xPJJg09I9vm6vmWS
         IEJNEuyANE7FPHkskFL8r4xpzQckq66+4XvnBV+H5We1v2F0OodWgh7kIvES+Edj9oJd
         I2GNtocrn5wEnoIWPcbQ5K8jlM6K6Hf/1v3eYPLfIoBCUqfUAAcxeq6RQ1aAAm8xefci
         2RFmqtL+s9oTDAQrmnU0sD9Q+84WL4wDxMQmnuxeWP70v8WDzd7i2McM8/SlK1Fp6eMG
         duAw==
X-Gm-Message-State: APjAAAX4XHGRQJ6gN2izjXbRITMBeGyZ3kBZPM8oqhchCBiVwVyEl4Lq
        QpN22u8ZpZb8CP7Y3lmPP/jxMw==
X-Google-Smtp-Source: APXvYqz1cHGnFV2c26Yq8lWgWFigtzB9Z2gxdmJXAG64GHifi4xxw7rXJ++5iixNDSYxTdVGWHdErQ==
X-Received: by 2002:adf:f788:: with SMTP id q8mr19337838wrp.181.1557787630962;
        Mon, 13 May 2019 15:47:10 -0700 (PDT)
Received: from andrea ([89.22.71.151])
        by smtp.gmail.com with ESMTPSA id u9sm1451813wmd.14.2019.05.13.15.47.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 15:47:10 -0700 (PDT)
Date:   Tue, 14 May 2019 00:47:03 +0200
From:   Andrea Parri <andrea.parri@amarulasolutions.com>
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/5] ceph: fix improper use of smp_mb__before_atomic()
Message-ID: <20190513224703.GA2957@andrea>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1556568902-12464-5-git-send-email-andrea.parri@amarulasolutions.com>
 <20190430082332.GB2677@hirez.programming.kicks-ass.net>
 <CAAM7YA=YOM79GJK8b7OOQbzT_-sYRD2UFHYithY7Li1yQt5Hog@mail.gmail.com>
 <20190509205452.GA4359@andrea>
 <6956e700-ef56-7f20-4e6c-3ad86c9fd89e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6956e700-ef56-7f20-4e6c-3ad86c9fd89e@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

> >>>         /*
> >>>          * XXX: the comment that explain this barrier goes here.
> >>>          */
> >>>
> >>
> >>makes sure operations that setup readdir cache (update page cache and
> >>i_size) are strongly ordered with following atomic64_set.
> >
> >Thanks for the suggestion, Yan.
> >
> >To be clear: would you like me to integrate your comment and resend?
> >any other suggestions?
> >
> 
> Yes, please

Will do: I'll let the merge window close and send v2 on top of -rc1.

Thanks,
  Andrea
