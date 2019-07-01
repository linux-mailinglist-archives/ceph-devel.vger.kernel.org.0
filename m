Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C6A5BA4D
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 13:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfGALFp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 07:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbfGALFp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 07:05:45 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ED3520673;
        Mon,  1 Jul 2019 11:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561979144;
        bh=CoUd3lBOCek2us46jwmufhU2GBeZW9WTgExSlk0v0WY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AHd7mAR+OYPhZR7x5qch3sQM4+JoIPPJ9B+SbvS4Z1b+W8tko5AwbOLTVXYyKv9FB
         X3n1bZYOekxSvmbkrZOB4Q/1oYfr0ANy4bcA811gAGLsulCotqpFcjbKMKJfIs0qLA
         qn4bb4wCALka0yqo8wLvFetzPzSEGDcvrfHF4NTA=
Message-ID: <89a64abbff9a08d8df6fb6d14d51255407f6d957.camel@kernel.org>
Subject: Re: [PATCH 17/20] libceph: export osd_req_op_data() macro
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Date:   Mon, 01 Jul 2019 07:05:42 -0400
In-Reply-To: <20190625144111.11270-18-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
         <20190625144111.11270-18-idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-06-25 at 16:41 +0200, Ilya Dryomov wrote:
> We already have one exported wrapper around it for extent.osd_data and
> rbd_object_map_update_finish() needs another one for cls.request_data.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  include/linux/ceph/osd_client.h | 8 ++++++++
>  net/ceph/osd_client.c           | 8 --------
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index edb191c40a5c..44100a4f0808 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -389,6 +389,14 @@ extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
>  void ceph_osdc_update_epoch_barrier(struct ceph_osd_client *osdc, u32 eb);
>  void ceph_osdc_abort_requests(struct ceph_osd_client *osdc, int err);
>  
> +#define osd_req_op_data(oreq, whch, typ, fld)				\
> +({									\
> +	struct ceph_osd_request *__oreq = (oreq);			\
> +	unsigned int __whch = (whch);					\
> +	BUG_ON(__whch >= __oreq->r_num_ops);				\
> +	&__oreq->r_ops[__whch].typ.fld;					\
> +})
> +
>  extern void osd_req_op_init(struct ceph_osd_request *osd_req,
>  			    unsigned int which, u16 opcode, u32 flags);
>  
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index cc2bf296583d..22e8ccc1f975 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -171,14 +171,6 @@ static void ceph_osd_data_bvecs_init(struct ceph_osd_data *osd_data,
>  	osd_data->num_bvecs = num_bvecs;
>  }
>  
> -#define osd_req_op_data(oreq, whch, typ, fld)				\
> -({									\
> -	struct ceph_osd_request *__oreq = (oreq);			\
> -	unsigned int __whch = (whch);					\
> -	BUG_ON(__whch >= __oreq->r_num_ops);				\
> -	&__oreq->r_ops[__whch].typ.fld;					\
> -})
> -
>  static struct ceph_osd_data *
>  osd_req_op_raw_data_in(struct ceph_osd_request *osd_req, unsigned int which)
>  {

Reviewed-by: Jeff Layton <jlayton@kernel.org>

