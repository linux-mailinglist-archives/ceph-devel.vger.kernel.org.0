Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8BA545513
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 21:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbiFITjs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 15:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbiFITjr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 15:39:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97E926C
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 12:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7782D61E48
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 19:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65546C34114;
        Thu,  9 Jun 2022 19:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654803584;
        bh=OVFUm2fJ3yDQbVpPnJbe5jxQAoG01DcUCXwi6E7mcaI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VdgegQlKKuUnu/R7DvpJd9EkqGTxVQwkNMT2MsNZ/XFhdx6qhB+gWXN0IvOa9zpQL
         hTZi88Kyq3kLp8y7rD2cUmwXf6WC95FxEfP1ugxFT66ccTyyPmwFdvcAkCPw2kiTZD
         pcflig0VrqxC4xiQprPw9ZL7IgI8GoQChiw2oU6n2gdqbDwL4Xr1T/OF/afOmZJPcw
         cAL9aRCHZPL53PuFVVmIDeaxJzyxXXAQDL26mPc3H/S5/sYFWAhhSnRqyHLiDURta/
         Ivctfly0YDxXsnZkmIpxZ9z7SiPutP0+9EUy4acaQP29HW9g2rEo6DgDvGaUPDm2Sb
         xwe2nM8Yxw5zQ==
Message-ID: <f6074a43e6ebeced5e53578c211b64dd80f7bb3a.camel@kernel.org>
Subject: Re: [PATCH 1/2] libceph: add new iov_iter-based ceph_msg_data_type
 and ceph_osd_data_type
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, dhowells@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 09 Jun 2022 15:39:43 -0400
In-Reply-To: <20220609193423.167942-2-jlayton@kernel.org>
References: <20220609193423.167942-1-jlayton@kernel.org>
         <20220609193423.167942-2-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-06-09 at 15:34 -0400, Jeff Layton wrote:
> Add an iov_iter to the unions in ceph_msg_data and ceph_msg_data_cursor.
> Instead of requiring a list of pages or bvecs, we can just use an
> iov_iter directly, and avoid extra allocations.
>=20
> Note that we do assume that the pages represented by the iter are pinned
> such that they shouldn't incur page faults.
>=20
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/ceph/messenger.h  |  5 +++
>  include/linux/ceph/osd_client.h |  4 +++
>  net/ceph/messenger.c            | 64 +++++++++++++++++++++++++++++++++
>  net/ceph/osd_client.c           | 27 ++++++++++++++
>  4 files changed, 100 insertions(+)
>=20
> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenge=
r.h
> index 9fd7255172ad..c259021ca4a8 100644
> --- a/include/linux/ceph/messenger.h
> +++ b/include/linux/ceph/messenger.h
> @@ -123,6 +123,7 @@ enum ceph_msg_data_type {
>  	CEPH_MSG_DATA_BIO,	/* data source/destination is a bio list */
>  #endif /* CONFIG_BLOCK */
>  	CEPH_MSG_DATA_BVECS,	/* data source/destination is a bio_vec array */
> +	CEPH_MSG_DATA_ITER,	/* data source/destination is an iov_iter */
>  };
> =20
>  #ifdef CONFIG_BLOCK
> @@ -224,6 +225,7 @@ struct ceph_msg_data {
>  			bool		own_pages;
>  		};
>  		struct ceph_pagelist	*pagelist;
> +		struct iov_iter		iter;
>  	};
>  };
> =20
> @@ -248,6 +250,7 @@ struct ceph_msg_data_cursor {
>  			struct page	*page;		/* page from list */
>  			size_t		offset;		/* bytes from list */
>  		};
> +		struct iov_iter		iov_iter;
>  	};
>  };
> =20
> @@ -605,6 +608,8 @@ void ceph_msg_data_add_bio(struct ceph_msg *msg, stru=
ct ceph_bio_iter *bio_pos,
>  #endif /* CONFIG_BLOCK */
>  void ceph_msg_data_add_bvecs(struct ceph_msg *msg,
>  			     struct ceph_bvec_iter *bvec_pos);
> +void ceph_msg_data_add_iter(struct ceph_msg *msg,
> +			    struct iov_iter *iter);
> =20
>  struct ceph_msg *ceph_msg_new2(int type, int front_len, int max_data_ite=
ms,
>  			       gfp_t flags, bool can_fail);
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_cli=
ent.h
> index 6ec3cb2ac457..ef0ad534b6c5 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -108,6 +108,7 @@ enum ceph_osd_data_type {
>  	CEPH_OSD_DATA_TYPE_BIO,
>  #endif /* CONFIG_BLOCK */
>  	CEPH_OSD_DATA_TYPE_BVECS,
> +	CEPH_OSD_DATA_TYPE_ITER,
>  };
> =20
>  struct ceph_osd_data {
> @@ -131,6 +132,7 @@ struct ceph_osd_data {
>  			struct ceph_bvec_iter	bvec_pos;
>  			u32			num_bvecs;
>  		};
> +		struct iov_iter		iter;
>  	};
>  };
> =20
> @@ -501,6 +503,8 @@ void osd_req_op_extent_osd_data_bvecs(struct ceph_osd=
_request *osd_req,
>  void osd_req_op_extent_osd_data_bvec_pos(struct ceph_osd_request *osd_re=
q,
>  					 unsigned int which,
>  					 struct ceph_bvec_iter *bvec_pos);
> +void osd_req_op_extent_osd_iter(struct ceph_osd_request *osd_req,
> +				unsigned int which, struct iov_iter *iter);
> =20
>  extern void osd_req_op_cls_request_data_pagelist(struct ceph_osd_request=
 *,
>  					unsigned int which,
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 6056c8f7dd4c..cea0d75dfc49 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -964,6 +964,48 @@ static bool ceph_msg_data_pagelist_advance(struct ce=
ph_msg_data_cursor *cursor,
>  	return true;
>  }
> =20
> +static void ceph_msg_data_iter_cursor_init(struct ceph_msg_data_cursor *=
cursor,
> +					size_t length)
> +{
> +	struct ceph_msg_data *data =3D cursor->data;
> +
> +	cursor->iov_iter =3D data->iter;
> +	iov_iter_truncate(&cursor->iov_iter, length);
> +	cursor->resid =3D iov_iter_count(&cursor->iov_iter);
> +}
> +
> +static struct page *ceph_msg_data_iter_next(struct ceph_msg_data_cursor =
*cursor,
> +						size_t *page_offset,
> +						size_t *length)
> +{
> +	struct page *page;
> +	ssize_t len =3D iov_iter_get_pages(&cursor->iov_iter, &page, PAGE_SIZE,
> +					 1, page_offset);
> +
> +	BUG_ON(len < 0);
> +
> +	/*
> +	 * The assumption is that the pages represented by the iov_iter are
> +	 * pinned, with the references held by the upper-level callers, or
> +	 * by virtue of being under writeback. Given that, we should be
> +	 * safe to put the page reference here and still return the pointer.
> +	 */
> +	VM_BUG_ON_PAGE(!PageWriteback(page) && page_count(page) < 2, page);
> +	put_page(page);
> +	*length =3D min_t(size_t, len, cursor->resid);
> +	return page;
> +}
> +
> +static bool ceph_msg_data_iter_advance(struct ceph_msg_data_cursor *curs=
or,
> +					size_t bytes)
> +{
> +	BUG_ON(bytes > cursor->resid);
> +	cursor->resid -=3D bytes;
> +	iov_iter_advance(&cursor->iov_iter, bytes);
> +
> +	return cursor->resid;
> +}
> +
>  /*
>   * Message data is handled (sent or received) in pieces, where each
>   * piece resides on a single page.  The network layer might not
> @@ -991,6 +1033,9 @@ static void __ceph_msg_data_cursor_init(struct ceph_=
msg_data_cursor *cursor)
>  	case CEPH_MSG_DATA_BVECS:
>  		ceph_msg_data_bvecs_cursor_init(cursor, length);
>  		break;
> +	case CEPH_MSG_DATA_ITER:
> +		ceph_msg_data_iter_cursor_init(cursor, length);
> +		break;
>  	case CEPH_MSG_DATA_NONE:
>  	default:
>  		/* BUG(); */
> @@ -1038,6 +1083,9 @@ struct page *ceph_msg_data_next(struct ceph_msg_dat=
a_cursor *cursor,
>  	case CEPH_MSG_DATA_BVECS:
>  		page =3D ceph_msg_data_bvecs_next(cursor, page_offset, length);
>  		break;
> +	case CEPH_MSG_DATA_ITER:
> +		page =3D ceph_msg_data_iter_next(cursor, page_offset, length);
> +		break;
>  	case CEPH_MSG_DATA_NONE:
>  	default:
>  		page =3D NULL;
> @@ -1076,6 +1124,9 @@ void ceph_msg_data_advance(struct ceph_msg_data_cur=
sor *cursor, size_t bytes)
>  	case CEPH_MSG_DATA_BVECS:
>  		new_piece =3D ceph_msg_data_bvecs_advance(cursor, bytes);
>  		break;
> +	case CEPH_MSG_DATA_ITER:
> +		new_piece =3D ceph_msg_data_iter_advance(cursor, bytes);
> +		break;
>  	case CEPH_MSG_DATA_NONE:
>  	default:
>  		BUG();
> @@ -1874,6 +1925,19 @@ void ceph_msg_data_add_bvecs(struct ceph_msg *msg,
>  }
>  EXPORT_SYMBOL(ceph_msg_data_add_bvecs);
> =20
> +void ceph_msg_data_add_iter(struct ceph_msg *msg,
> +			    struct iov_iter *iter)
> +{
> +	struct ceph_msg_data *data;
> +
> +	data =3D ceph_msg_data_add(msg);
> +	data->type =3D CEPH_MSG_DATA_ITER;
> +	data->iter =3D *iter;
> +
> +	msg->data_length +=3D iov_iter_count(&data->iter);
> +}
> +EXPORT_SYMBOL(ceph_msg_data_add_iter);

I don't think this EXPORT_SYMBOL is actually needed. Nothing outside
libceph calls this. I've fixed this up in my tree, and can send a v2, or
you can just remove that line before merging.

> +
>  /*
>   * construct a new message with given type, size
>   * the new msg has a ref count of 1.
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 75761537c644..2a7e46524e71 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -171,6 +171,13 @@ static void ceph_osd_data_bvecs_init(struct ceph_osd=
_data *osd_data,
>  	osd_data->num_bvecs =3D num_bvecs;
>  }
> =20
> +static void ceph_osd_iter_init(struct ceph_osd_data *osd_data,
> +			       struct iov_iter *iter)
> +{
> +	osd_data->type =3D CEPH_OSD_DATA_TYPE_ITER;
> +	osd_data->iter =3D *iter;
> +}
> +
>  static struct ceph_osd_data *
>  osd_req_op_raw_data_in(struct ceph_osd_request *osd_req, unsigned int wh=
ich)
>  {
> @@ -264,6 +271,22 @@ void osd_req_op_extent_osd_data_bvec_pos(struct ceph=
_osd_request *osd_req,
>  }
>  EXPORT_SYMBOL(osd_req_op_extent_osd_data_bvec_pos);
> =20
> +/**
> + * osd_req_op_extent_osd_iter - Set up an operation with an iterator buf=
fer
> + * @osd_req: The request to set up
> + * @which: ?
> + * @iter: The buffer iterator
> + */
> +void osd_req_op_extent_osd_iter(struct ceph_osd_request *osd_req,
> +				unsigned int which, struct iov_iter *iter)
> +{
> +	struct ceph_osd_data *osd_data;
> +
> +	osd_data =3D osd_req_op_data(osd_req, which, extent, osd_data);
> +	ceph_osd_iter_init(osd_data, iter);
> +}
> +EXPORT_SYMBOL(osd_req_op_extent_osd_iter);
> +
>  static void osd_req_op_cls_request_info_pagelist(
>  			struct ceph_osd_request *osd_req,
>  			unsigned int which, struct ceph_pagelist *pagelist)
> @@ -346,6 +369,8 @@ static u64 ceph_osd_data_length(struct ceph_osd_data =
*osd_data)
>  #endif /* CONFIG_BLOCK */
>  	case CEPH_OSD_DATA_TYPE_BVECS:
>  		return osd_data->bvec_pos.iter.bi_size;
> +	case CEPH_OSD_DATA_TYPE_ITER:
> +		return iov_iter_count(&osd_data->iter);
>  	default:
>  		WARN(true, "unrecognized data type %d\n", (int)osd_data->type);
>  		return 0;
> @@ -954,6 +979,8 @@ static void ceph_osdc_msg_data_add(struct ceph_msg *m=
sg,
>  #endif
>  	} else if (osd_data->type =3D=3D CEPH_OSD_DATA_TYPE_BVECS) {
>  		ceph_msg_data_add_bvecs(msg, &osd_data->bvec_pos);
> +	} else if (osd_data->type =3D=3D CEPH_OSD_DATA_TYPE_ITER) {
> +		ceph_msg_data_add_iter(msg, &osd_data->iter);
>  	} else {
>  		BUG_ON(osd_data->type !=3D CEPH_OSD_DATA_TYPE_NONE);
>  	}

--=20
Jeff Layton <jlayton@kernel.org>
