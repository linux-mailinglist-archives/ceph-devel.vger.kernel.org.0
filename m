Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8BC76295
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2019 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfGZJbw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 26 Jul 2019 05:31:52 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:45907 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfGZJbw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 26 Jul 2019 05:31:52 -0400
Received: by mail-lj1-f182.google.com with SMTP id m23so50744750lje.12
        for <ceph-devel@vger.kernel.org>; Fri, 26 Jul 2019 02:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c7nks3WSfyg3HZLW40NFKu/hRgzYgFP4OdG6tbPgnhs=;
        b=psw/JyZ9XlcsneZ9omoE6Fga9XBKN+ORoSv7DxmZWQ7NE/gtG9UWqENNagSHxKelZM
         JfkT154NtfpiQu/1ULwp4iOcJPrDhmGTtXyi5X05SCZfsSRKEWtiedYzV4rIOYaEk/nS
         vI+2BLdbmbiTQH0HnWy3jgyVUuo/zAhcoRMXVGZnGbgIR6VPqQC0Zz1LMVPmu6YRpl40
         zVct7TqcV7ZWOez7aTbrlcFU+fEhkjqtVO/PcoUwKyu6XZhBOEnI1IsfvRtFTOhGb3kR
         s8R7xTL9WnoQ5YwmJ+L4gt0GFKsGXJ58u+Btp1ccQ8fdF4ufOThkhhE6biekbLB9jFgO
         qdCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c7nks3WSfyg3HZLW40NFKu/hRgzYgFP4OdG6tbPgnhs=;
        b=kOvdNSHze85YgxgBRP+PfJwTPgc1cTpn0poR0e3kGXftCK5TlwYTTI1nHO8G5cB31S
         BgCe98PvEnXt6wiQMRIQBlOMzO4H6rBZjTmuNCfmlZwPUe+f+D6o6giizVo54YL76D/q
         ixOkFB7LJH/9I/xXRlxxKXL9AUyamrL9W//gfC3BKhfQ1bEzBhwYmfyAMAq3+DJ1SLBf
         SikmsTGVTL+KxdklmNe+Tkjl/STx9Gw+kJe8+jmfUAPx4j7jeJbL3AAbRNxQOQWzDZ0d
         +5lJ0wHZz9sUaeuumJaVbN34DznddE+5npN0Lpwy+RIZLGnjYTZFGZ8lHu38hXuFrRtf
         TiKw==
X-Gm-Message-State: APjAAAUQEdslqZYtwLDu7gxpsNyJlDyOOFpdifjbNHnkmXGBGvnf+H1v
        VAnHBb0PfHjHbx2S1WtieUTGmazO+Q==
X-Google-Smtp-Source: APXvYqxH/BRVoT2P5ifthc+lcRhSrMQyqU93oii4j+9+n0+vizKuemB1coS0ZSB5uPDUqC2g2monMw==
X-Received: by 2002:a2e:6c14:: with SMTP id h20mr48965585ljc.38.1564133510354;
        Fri, 26 Jul 2019 02:31:50 -0700 (PDT)
Received: from localhost ([91.245.78.132])
        by smtp.gmail.com with ESMTPSA id i9sm8287178lfl.10.2019.07.26.02.31.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 02:31:49 -0700 (PDT)
From:   Mykola Golub <to.my.trociny@gmail.com>
X-Google-Original-From: Mykola Golub <mgolub@suse.de>
Date:   Fri, 26 Jul 2019 12:31:48 +0300
To:     Ajitha Robert <ajitharobert01@gmail.com>
Cc:     ceph-users@lists.ceph.com, ceph-users@ceph.com,
        ceph-devel@vger.kernel.org
Subject: Re: [ceph-users] Error in ceph rbd
 mirroring(rbd::mirror::InstanceWatcher: C_NotifyInstanceRequestfinish:
 resending after timeout)
Message-ID: <20190726093147.GA31242@gmail.com>
References: <CAEbG6hG7dAhg=Z9JUKcCCTOEPyXZ6cZcS=jar7SeL-5VTcqEgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEbG6hG7dAhg=Z9JUKcCCTOEPyXZ6cZcS=jar7SeL-5VTcqEgA@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 26, 2019 at 12:31:59PM +0530, Ajitha Robert wrote:
>  I have a rbd mirroring setup with primary and secondary clusters as peers
> and I have a pool enabled image mode.., In this i created a rbd image ,
> enabled with journaling.
> But whenever i enable mirroring on the image,  I m getting error in
> rbdmirror.log and  osd.log.
> I have increased the timeouts.. nothing worked and couldnt traceout the
> error
> please guide me to solve this error.
> 
> *Logs*
> http://paste.openstack.org/show/754766/

What do you mean by "nothing worked"? According to mirroring status
the image is mirroring: it is in "up+stopped" state on the primary as
expected, and in "up+replaying" state on the secondary with 0 entries
behind master.

The "failed to get omap key" error in the osd log is harmless, and
just a week ago the fix was merged upstream not to display it.

The cause of "InstanceWatcher: ... resending after timeout" error in
the rbd-mirror log is not clear but if it is not repeating it is
harmless too.

I see you were trying to map the image with krbd. It is expected to
fail as the krbd does not support "journaling" feature, which is
necessary for mirroring. You can access those images only with librbd
(e.g. mapping with rbd-nbd driver or via qemu).

-- 
Mykola Golub
