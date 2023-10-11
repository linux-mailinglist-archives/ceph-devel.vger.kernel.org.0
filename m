Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A601E7C5564
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Oct 2023 15:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbjJKN1L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Oct 2023 09:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbjJKN1K (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Oct 2023 09:27:10 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E05AF
        for <ceph-devel@vger.kernel.org>; Wed, 11 Oct 2023 06:27:08 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-40651a726acso63323285e9.1
        for <ceph-devel@vger.kernel.org>; Wed, 11 Oct 2023 06:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697030827; x=1697635627; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7sb7D9HOHQNMydcxnBv13OfNd2mqurTiUr3UspR5ooI=;
        b=KZuSE21DIT/QF5S5BRX51M/e3Z1BIJjgQ1UDFyW17Q3UgNwn4t3TmqYUWoolb1VwqH
         hv0dh0ZJuLLZsFbCDbF3ZqsE1gBR2CicwOM61JlvCBhUa+qxO+I06TXc1JlZphLkHuQA
         4IvEMyWl03bnK3w+RpP0/gXZCP3OiAupQb1oxYs0+9f48spdGV+TlB+/+tW0l0Ngh9eW
         LmBNhbbMliPAz1/Q2c3eW3sgGmiXyHDNGAD+vKjQD0IdpQK75TJsuO2udvugaPpthS8P
         q8FDAFBl1j4+6XDPUwiHAOMeq7UjWb7K+DktLwT//5F0mtiHMw8hGZO808/6SzQ6keJG
         DZ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697030827; x=1697635627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7sb7D9HOHQNMydcxnBv13OfNd2mqurTiUr3UspR5ooI=;
        b=dgCSWtWnuodRob1BSfT/IYr7Xio8DKMHMd3KLwOg1JjH4IOyd9/p2U/tWUYGz+ahPt
         dwp5YvydJ48UVatumJ1issQ4Upk+aeJA1/R8B7UYrSBVqws1gBzuFCfooAfwEH3EFbGB
         zKy8GKrM9pzwgXKmotrR1+mNiSkTqgHxo/4gAO8VS+N57/QXXqVtGeH+uIQ1UIn53gRr
         07nZ3vPDuqro1gfXKIWv5QRM6xgPt2XvWbAJ4kyNow5Am9BuH+z84QYJWmDp5GEpWBuz
         au+L0mtiY60iaQAjeEBFJ4ibavMOuVfLVhf5qKjBwsprpe32y21N5mX4rj0mhzWHjT88
         PbUQ==
X-Gm-Message-State: AOJu0Yzg9m68xufz+15KG0OOP8yTJ+Xsu69Sirpe+VADSkhs4Jvf8Reo
        hNXlH2xQ7m4uzj7QeLctzExMJw==
X-Google-Smtp-Source: AGHT+IHdzjXeYl0Sj/71enbZnXpMpL2LA1GgesvlgQOVgPqClnz6+dwC2NysdkRMCr/+oh3IG3Jo4g==
X-Received: by 2002:a05:600c:2284:b0:401:b493:f7c1 with SMTP id 4-20020a05600c228400b00401b493f7c1mr19620544wmf.35.1697030826606;
        Wed, 11 Oct 2023 06:27:06 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id bd5-20020a05600c1f0500b004030e8ff964sm19358856wmb.34.2023.10.11.06.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 06:27:05 -0700 (PDT)
Date:   Wed, 11 Oct 2023 16:27:03 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [bug report] libceph: add new iov_iter-based ceph_msg_data_type
 and ceph_osd_data_type
Message-ID: <b261fcc8-681d-414c-a881-453635c8bd90@kadam.mountain>
References: <c5a75561-b6c7-4217-9e70-4b3212fd05f8@moroto.mountain>
 <87c8dc9d4734e6e2a0250531bc08140880b4523d.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87c8dc9d4734e6e2a0250531bc08140880b4523d.camel@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Oct 11, 2023 at 08:06:59AM -0400, Jeff Layton wrote:
> On Wed, 2023-10-11 at 12:50 +0300, Dan Carpenter wrote:
> > Hello Jeff Layton,
> > 
> > To be honest, I'm not sure why I am only seeing this now.  These
> > warnings are hard to analyse because they involve such a long call tree.
> > Anyway, hopefully it's not too complicated for you since you know the
> > code.
> > 
> > The patch dee0c5f83460: "libceph: add new iov_iter-based
> > ceph_msg_data_type and ceph_osd_data_type" from Jul 1, 2022
> > (linux-next), leads to the following Smatch static checker warning:
> > 
> > 	lib/iov_iter.c:905 want_pages_array()
> > 	warn: sleeping in atomic context
> > 
> > lib/iov_iter.c
> >     896 static int want_pages_array(struct page ***res, size_t size,
> >     897                             size_t start, unsigned int maxpages)
> >     898 {
> >     899         unsigned int count = DIV_ROUND_UP(size + start, PAGE_SIZE);
> >     900 
> >     901         if (count > maxpages)
> >     902                 count = maxpages;
> >     903         WARN_ON(!count);        // caller should've prevented that
> >     904         if (!*res) {
> > --> 905                 *res = kvmalloc_array(count, sizeof(struct page *), GFP_KERNEL);
> >     906                 if (!*res)
> >     907                         return 0;
> >     908         }
> >     909         return count;
> >     910 }
> > 
> > 
> > prep_next_sparse_read() <- disables preempt
> > -> advance_cursor()
> >    -> ceph_msg_data_next()
> >       -> ceph_msg_data_iter_next()
> >          -> iov_iter_get_pages2()
> >             -> __iov_iter_get_pages_alloc()
> >                -> want_pages_array()
> > 
> > The prep_next_sparse_read() functions hold the spin_lock(&o->o_requests_lock);
> > lock so it can't sleep.  But iov_iter_get_pages2() seems like a sleeping
> > operation.
> > 
> > 
> 
> I think this is a false alarm, but I'd appreciate a sanity check:
> 
> iov_iter_get_pages2 has this:
> 
> 	BUG_ON(!pages);
> 
> ...which should ensure that *res won't be NULL when want_pages_array is
> called. That said, this seems like kind of a fragile thing to rely on.
> Should we do something to make this a bit less subtle?

Nah, forget about it.  Let's just leave this conversation up on lore so
if anyone has questions about it they can read this thread.  The
BUG_ON(!pages) is really straight forward to understand.

regards,
dan carpenter

