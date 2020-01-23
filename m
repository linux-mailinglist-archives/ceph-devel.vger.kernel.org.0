Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E66147102
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jan 2020 19:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgAWSpa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jan 2020 13:45:30 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:45153 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbgAWSpa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Jan 2020 13:45:30 -0500
Received: by mail-il1-f195.google.com with SMTP id p8so2820447iln.12;
        Thu, 23 Jan 2020 10:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jqmdmEm77sBszWxMUPKZElU9PD8xFdEXqN5HtNYE0uU=;
        b=DmKpHAhlzwFjW7eRo23NnmHfzO88DK0KRRsFl5leUCFKUA7M1ccDOqfMfYXlttbgDR
         oqbzY0umDtT8wYedyF7VeSqItjtlf5/znvJPJh/Ecdu5DELDwvlmwaHxTg63qs8f/FGA
         yUyD8pBzI3xjEPiHoEntMxPErGQRXferxcs4C8DQ4+ig+2ZTpvy0BZtn8uIIG6r2rl3Q
         eomVhvpchihAqc5ZSnvb7R6WBhfdhWndrmPok1O+6DDM/zJZZbF+QCY3ygeAzEumrrnq
         raGzn7sgpZFfEQ9JxMMOixOoLfjAqazHD7IFRMg2JISUemEzDkdLXU+L4MXFlce0aTqE
         hncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jqmdmEm77sBszWxMUPKZElU9PD8xFdEXqN5HtNYE0uU=;
        b=UBXWK4+0ShfVx7y9BlAXPC63e/2JsjcSsLIFCW7v9HFzf0HRPL6QdaZwMrIQJNdeSh
         dCswHQw/H3KOtaczfV+uc615c6GNAacYmf/JcmNl21y3Nx3WqFsbx9PCEj+oq1JZaq+T
         ZlI7wgZd6+XBdaEtK3MTKgId+Yce9mYgdzsLB7j2nXrnliGSN+Zp8ohK5leFwYJSom/l
         lfppxnBVgEZE99Kogjk0T7nA34ho+3IoFKWg+DssvjJMukqDIMlO46DEbgOz3C1zttl2
         oDnGSaoZI5RPOffLQMRUXm3gEcPotToCVonlyUOn0DzD2dNVhYLAo8DOX5/qRIt9U36M
         3Vng==
X-Gm-Message-State: APjAAAVUKxhuXm9jBychbHHLVAYFUh5MPPI0KMGVwwFMOdaCcyEXpCQG
        m0xzlfZs//MC2YgvIE6dm73kgCslQTdBRExDefL7SMk4mUY=
X-Google-Smtp-Source: APXvYqzrD010a8tVjlhYrS9I6Mk8vwmBCjYvKtTNSGeY2icOWGWBCtsxLW/HuGrq/vrSXWKFMtfRtASIe3dsKmseTFQ=
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr12785384ilq.215.1579805129635;
 Thu, 23 Jan 2020 10:45:29 -0800 (PST)
MIME-Version: 1.0
References: <20200123124433.121939-1-hare@suse.de>
In-Reply-To: <20200123124433.121939-1-hare@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 23 Jan 2020 19:45:32 +0100
Message-ID: <CAOi1vP8Q44jLNoq+LTm8GRX687wfwLkJ3WRW_DWvY7nYUtPQxQ@mail.gmail.com>
Subject: Re: [PATCH] rbd: set the 'device' link in sysfs
To:     Hannes Reinecke <hare@suse.de>
Cc:     Sage Weil <sage@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        David Disseldorp <ddiss@suse.com>,
        Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jan 23, 2020 at 1:44 PM Hannes Reinecke <hare@suse.de> wrote:
>
> The rbd driver already provides additional information in sysfs
> under /sys/bus/rbd, so we should set the 'device' link in the block
> device to reference this information.
>
> Cc: David Disseldorp <ddiss@suse.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/block/rbd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 9f1f8689e316..3240b7744aeb 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -6938,7 +6938,7 @@ static ssize_t do_rbd_add(struct bus_type *bus,
>         if (rc)
>                 goto err_out_image_lock;
>
> -       add_disk(rbd_dev->disk);
> +       device_add_disk(&rbd_dev->dev, rbd_dev->disk, NULL);
>         /* see rbd_init_disk() */
>         blk_put_queue(rbd_dev->disk->queue);

Hi Hannes,

I looked at this a while ago and didn't go through with the patch
because I wasn't sure whether this symlink can point to something
arbitrary.  IIRC it usually points a couple of levels up, to some
parent.  In the rbd case, this would be a completely different tree:
/sys/devices/virtual -> /sys/bus/rbd.

Do you know if there is precedent for this in some other driver?
Are you sure it's not going to break any assumptions?

How did this came up?  I'm curious because rbd(8) is only utility
that I know of that (somewhat) cares.

Thanks,

                Ilya
