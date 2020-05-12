Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DAD1CFCDB
	for <lists+ceph-devel@lfdr.de>; Tue, 12 May 2020 20:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbgELSKM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 May 2020 14:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgELSKM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 12 May 2020 14:10:12 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90EBD20673;
        Tue, 12 May 2020 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589307012;
        bh=61xlZrbWPX41z1uM+eXXyvV3cA4LQt15Qefbitoigw0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JJHdGC9ygYypPUd1I+twur74mNYaZUQ5pYNNqdx9tjuuIEU2GYaDeDZZTRVkUQC50
         uDfivLe3wue3jJ1Ew65GmFha1KGg+MnX3VHgfI1sqh/yCETzZXRjuAXDG0hYbcoujs
         xrPLaO40i+XM3BsbP644u01c4jv06U8Kz0jAChGA=
Date:   Tue, 12 May 2020 13:14:46 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rbd: Replace zero-length array with flexible-array
Message-ID: <20200512181446.GJ4897@embeddedor>
References: <20200507191932.GA15991@embeddedor>
 <CAOi1vP9GfENfy_D_iOeUrweUk2CTcz+2GXGg3M6y+bvQs_zqMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP9GfENfy_D_iOeUrweUk2CTcz+2GXGg3M6y+bvQs_zqMw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 08, 2020 at 09:54:12AM +0200, Ilya Dryomov wrote:
> 
> Applied (folded into libceph patch).
> 

Thanks, Ilya. 

--
Gustavo
