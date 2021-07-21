Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C023D10DF
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Jul 2021 16:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238582AbhGUN2T (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Jul 2021 09:28:19 -0400
Received: from verein.lst.de ([213.95.11.211]:58868 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234380AbhGUN2S (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 21 Jul 2021 09:28:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9B6F767373; Wed, 21 Jul 2021 16:08:52 +0200 (CEST)
Date:   Wed, 21 Jul 2021 16:08:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: Re: [PATCH] rbd: resurrect setting of disk->private_data in
 rbd_init_disk()
Message-ID: <20210721140852.GA9523@lst.de>
References: <20210721130950.3359-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721130950.3359-1-idryomov@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Oops, sorry. Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
