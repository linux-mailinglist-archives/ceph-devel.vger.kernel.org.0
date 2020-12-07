Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B5A2D1846
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Dec 2020 19:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgLGSOZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Dec 2020 13:14:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgLGSOZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 7 Dec 2020 13:14:25 -0500
Date:   Mon, 7 Dec 2020 10:13:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607364824;
        bh=gCgAvkXT5IcZqeDOSIos+2lUJLoXppjLnbnmm7iABTQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=FXvgRMLzbqdzex6v9XJtk+QYQ3jOE7bEdeopiDZYCQISM/QgSzITgAXWz5WqGgRWb
         GFf9WIYfblqZ+Cy58bYLmaoZnKzTh2QBfqCo7PokX3nOUxM/vWnc8chQJbIP9XnX1j
         zxMoFcawpthxmfVJ41VQaJvLNXkIrI4MtX2cex1o3VSrDaWtusqufao8X5b8+8W6Ig
         p5tTqL2ewbNHqMHvkw/8Nz/kiIpzX2hYtAgQHQ5d5bW4EfOKFPRxaTudaYFa1IDmDA
         migWBgPCJ10F0eP/K3i1ih67T7i/qgFVk2Fw8CAMmeHeDRnOlV3Dd3vZcS1d3V5jPv
         jv5Yl/eNXjc4Q==
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 6/6] nvme: allow revalidate to set a namespace read-only
Message-ID: <20201207181341.GD3679937@dhcp-10-100-145-180.wdc.com>
References: <20201207131918.2252553-1-hch@lst.de>
 <20201207131918.2252553-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207131918.2252553-7-hch@lst.de>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Dec 07, 2020 at 02:19:18PM +0100, Christoph Hellwig wrote:
> Unconditionally call set_disk_ro now that it only updates the hardware
> state.  This allows to properly set up the Linux devices read-only when
> the controller turns a previously writable namespace read-only.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>
