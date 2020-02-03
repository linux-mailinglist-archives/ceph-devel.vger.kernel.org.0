Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4741502B4
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 09:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgBCIgw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 03:36:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48880 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgBCIgw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 03:36:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cNohL4gPXlIFF8vNn5lCA+dpzd2wI3A5XwVmPbxTkgQ=; b=BTWQxpfrHPaBam2GJpwEeI2q7
        9iYoo6Blh+3xg+Ghk6wHFHO6zTp+3z9kjvStaU5Win25NMaoT3lKMuyVw+OSqXQ6Lpuqd2sJk50da
        Tiu3w6OmnPcFuSSALuqMsjPgLQUovUcetxT8AsmLnZj/FvkBHAvKeTpcL+8+fvo3fF8yq0D9gVPuD
        L7xAa+cqdkKWMoVO98wLuL3v6z/QHCJ0xAUI+hY9dSD/B4sRDf+r4vuyZX5LFyu/4pb5qy0NTjjPh
        1ntq0HPuLRzYg5rWyqP7yRWe7ah0cqhBw2Jx8HvoGcwbO88CVDbJlIq8x6yE47/zC8VE8mV04xdX2
        WQNJFR/0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iyXDq-0003ZX-3w; Mon, 03 Feb 2020 08:36:46 +0000
Date:   Mon, 3 Feb 2020 00:36:46 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     xiubli@redhat.com
Cc:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com,
        sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Subject: Re: [RFC PATCH] ceph: do not direct write executes in parallel if
 O_APPEND is set
Message-ID: <20200203083646.GB5005@infradead.org>
References: <20200131133619.14209-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131133619.14209-1-xiubli@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jan 31, 2020 at 08:36:19AM -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> In O_APPEND & O_DIRECT mode, the data from different writers will
> be possiblly overlapping each other. Just use the exclusive clock
> instead in O_APPEND & O_DIRECT mode.

s/clock/lock/
