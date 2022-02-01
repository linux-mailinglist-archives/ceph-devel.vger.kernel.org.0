Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C484A5D5F
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Feb 2022 14:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238353AbiBANYB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Feb 2022 08:24:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57008 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbiBANYB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Feb 2022 08:24:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD47A61515
        for <ceph-devel@vger.kernel.org>; Tue,  1 Feb 2022 13:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005CBC340EB;
        Tue,  1 Feb 2022 13:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643721840;
        bh=GRjQnLyesCpDgScrdonXAThe9AISpziXNfu9CqqfYeA=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=ZR2oGPHzKI2yJLgXWJ0jg2MCl8V9iROC0ifzlN18DKg2K24fcnj5Jwk/yRXmWckyk
         XRD0wa7/yAj5pnDLcbNUwwrickptI1nSrmGIeIxn4DH15jYGQJO5TdngO5mIYTW/zy
         1YOWR+e9KZ5krxBh1qhuQDWJp4mzC9WOht2jchZugRIZIxod0zLBEhkWSkMaqYw0cR
         m525s35polVehcco5gJh1seTCpCRTrgsfgfVKvMo2C0g1YDLlw1ImGpHfW0llHbh3k
         tNSV7T69/alBnIAk8KHXLn/UxyDT1sWcL7O1ID/Xp2FLXsnER6VJ2QQpZEEB6GIkFL
         8vkkiWmaKMj7w==
Message-ID: <04c35b85035fdce2678c78b430f18cab1a571a10.camel@kernel.org>
Subject: Re: [PATCH 2/2] libceph: optionally use bounce buffer on recv path
 in crc mode
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Tue, 01 Feb 2022 08:23:58 -0500
In-Reply-To: <20220131155846.32411-3-idryomov@gmail.com>
References: <20220131155846.32411-1-idryomov@gmail.com>
         <20220131155846.32411-3-idryomov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-01-31 at 16:58 +0100, Ilya Dryomov wrote:
> Both msgr1 and msgr2 in crc mode are zero copy in the sense that
> message data is read from the socket directly into the destination
> buffer.  We assume that the destination buffer is stable (i.e. remains
> unchanged while it is being read to) though.  Otherwise, CRC errors
> ensue:
> 
>   libceph: read_partial_message 0000000048edf8ad data crc 1063286393 != exp. 228122706
>   libceph: osd1 (1)192.168.122.1:6843 bad crc/signature
> 
>   libceph: bad data crc, calculated 57958023, expected 1805382778
>   libceph: osd2 (2)192.168.122.1:6876 integrity error, bad crc
> 
> Introduce rxbounce option to enable use of a bounce buffer when
> receiving message data.  In particular this is needed if a mapped
> image is a Windows VM disk, passed to QEMU.  Windows has a system-wide
> "dummy" page that may be mapped into the destination buffer (potentially
> more than once into the same buffer) by the Windows Memory Manager in
> an effort to generate a single large I/O [1][2].  QEMU makes a point of
> preserving overlap relationships when cloning I/O vectors, so krbd gets
> exposed to this behaviour.
> 
> [1] "What Is Really in That MDL?"
>     https://docs.microsoft.com/en-us/previous-versions/windows/hardware/design/dn614012(v=vs.85)
> [2] https://blogs.msmvps.com/kernelmustard/2005/05/04/dummy-pages/
> 
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=1973317
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  include/linux/ceph/libceph.h   |  1 +
>  include/linux/ceph/messenger.h |  1 +
>  net/ceph/ceph_common.c         |  7 ++++
>  net/ceph/messenger.c           |  4 +++
>  net/ceph/messenger_v1.c        | 54 +++++++++++++++++++++++++++----
>  net/ceph/messenger_v2.c        | 58 ++++++++++++++++++++++++++--------
>  6 files changed, 105 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index 6a89ea410e43..edf62eaa6285 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -35,6 +35,7 @@
>  #define CEPH_OPT_TCP_NODELAY      (1<<4) /* TCP_NODELAY on TCP sockets */
>  #define CEPH_OPT_NOMSGSIGN        (1<<5) /* don't sign msgs (msgr1) */
>  #define CEPH_OPT_ABORT_ON_FULL    (1<<6) /* abort w/ ENOSPC when full */
> +#define CEPH_OPT_RXBOUNCE         (1<<7) /* double-buffer read data */
>  
>  #define CEPH_OPT_DEFAULT   (CEPH_OPT_TCP_NODELAY)
>  
> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> index 6c6b6ea52bb8..e7f2fb2fc207 100644
> --- a/include/linux/ceph/messenger.h
> +++ b/include/linux/ceph/messenger.h
> @@ -461,6 +461,7 @@ struct ceph_connection {
>  	struct ceph_msg *out_msg;        /* sending message (== tail of
>  					    out_sent) */
>  
> +	struct page *bounce_page;
>  	u32 in_front_crc, in_middle_crc, in_data_crc;  /* calculated crc */
>  
>  	struct timespec64 last_keepalive_ack; /* keepalive2 ack stamp */
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index ecc400a0b7bb..4c6441536d55 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -246,6 +246,7 @@ enum {
>  	Opt_cephx_sign_messages,
>  	Opt_tcp_nodelay,
>  	Opt_abort_on_full,
> +	Opt_rxbounce,
>  };
>  
>  enum {
> @@ -295,6 +296,7 @@ static const struct fs_parameter_spec ceph_parameters[] = {
>  	fsparam_u32	("osdkeepalive",		Opt_osdkeepalivetimeout),
>  	fsparam_enum	("read_from_replica",		Opt_read_from_replica,
>  			 ceph_param_read_from_replica),
> +	fsparam_flag	("rxbounce",			Opt_rxbounce),

Yuck.

It sure would be nice to automagically detect when this was needed
somehow. The option is fine once you know you need it, but getting to
that point may be painful.

Maybe we should we make the warnings about failing crc messages suggest
rxbounce? We could also consider making it so that when you fail a crc
check and the connection is reset, that the new connection enables
rxbounce automatically?

>  	fsparam_enum	("ms_mode",			Opt_ms_mode,
>  			 ceph_param_ms_mode),
>  	fsparam_string	("secret",			Opt_secret),
> @@ -584,6 +586,9 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
>  	case Opt_abort_on_full:
>  		opt->flags |= CEPH_OPT_ABORT_ON_FULL;
>  		break;
> +	case Opt_rxbounce:
> +		opt->flags |= CEPH_OPT_RXBOUNCE;
> +		break;
>  
>  	default:
>  		BUG();
> @@ -660,6 +665,8 @@ int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
>  		seq_puts(m, "notcp_nodelay,");
>  	if (show_all && (opt->flags & CEPH_OPT_ABORT_ON_FULL))
>  		seq_puts(m, "abort_on_full,");
> +	if (opt->flags & CEPH_OPT_RXBOUNCE)
> +		seq_puts(m, "rxbounce,");
>  
>  	if (opt->mount_timeout != CEPH_MOUNT_TIMEOUT_DEFAULT)
>  		seq_printf(m, "mount_timeout=%d,",
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 45eba2dcb67a..d3bb656308b4 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -515,6 +515,10 @@ static void ceph_con_reset_protocol(struct ceph_connection *con)
>  		ceph_msg_put(con->out_msg);
>  		con->out_msg = NULL;
>  	}
> +	if (con->bounce_page) {
> +		__free_page(con->bounce_page);
> +		con->bounce_page = NULL;
> +	}
>  
>  	if (ceph_msgr2(from_msgr(con->msgr)))
>  		ceph_con_v2_reset_protocol(con);
> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> index 2cb5ffdf071a..6b014eca3a13 100644
> --- a/net/ceph/messenger_v1.c
> +++ b/net/ceph/messenger_v1.c
> @@ -992,8 +992,7 @@ static int read_partial_message_section(struct ceph_connection *con,
>  
>  static int read_partial_msg_data(struct ceph_connection *con)
>  {
> -	struct ceph_msg *msg = con->in_msg;
> -	struct ceph_msg_data_cursor *cursor = &msg->cursor;
> +	struct ceph_msg_data_cursor *cursor = &con->in_msg->cursor;
>  	bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
>  	struct page *page;
>  	size_t page_offset;
> @@ -1001,9 +1000,6 @@ static int read_partial_msg_data(struct ceph_connection *con)
>  	u32 crc = 0;
>  	int ret;
>  
> -	if (!msg->num_data_items)
> -		return -EIO;
> -
>  	if (do_datacrc)
>  		crc = con->in_data_crc;
>  	while (cursor->total_resid) {
> @@ -1031,6 +1027,46 @@ static int read_partial_msg_data(struct ceph_connection *con)
>  	return 1;	/* must return > 0 to indicate success */
>  }
>  
> +static int read_partial_msg_data_bounce(struct ceph_connection *con)
> +{
> +	struct ceph_msg_data_cursor *cursor = &con->in_msg->cursor;
> +	struct page *page;
> +	size_t off, len;
> +	u32 crc;
> +	int ret;
> +
> +	if (unlikely(!con->bounce_page)) {
> +		con->bounce_page = alloc_page(GFP_NOIO);
> +		if (!con->bounce_page) {
> +			pr_err("failed to allocate bounce page\n");
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	crc = con->in_data_crc;
> +	while (cursor->total_resid) {
> +		if (!cursor->resid) {
> +			ceph_msg_data_advance(cursor, 0);
> +			continue;
> +		}
> +
> +		page = ceph_msg_data_next(cursor, &off, &len, NULL);
> +		ret = ceph_tcp_recvpage(con->sock, con->bounce_page, 0, len);
> +		if (ret <= 0) {
> +			con->in_data_crc = crc;
> +			return ret;
> +		}
> +
> +		crc = crc32c(crc, page_address(con->bounce_page), ret);
> +		memcpy_to_page(page, off, page_address(con->bounce_page), ret);
> +
> +		ceph_msg_data_advance(cursor, ret);
> +	}
> +	con->in_data_crc = crc;
> +
> +	return 1;	/* must return > 0 to indicate success */
> +}
> +
>  /*
>   * read (part of) a message.
>   */
> @@ -1141,7 +1177,13 @@ static int read_partial_message(struct ceph_connection *con)
>  
>  	/* (page) data */
>  	if (data_len) {
> -		ret = read_partial_msg_data(con);
> +		if (!m->num_data_items)
> +			return -EIO;
> +
> +		if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE))
> +			ret = read_partial_msg_data_bounce(con);
> +		else
> +			ret = read_partial_msg_data(con);
>  		if (ret <= 0)
>  			return ret;
>  	}
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index d34349f112b0..8a101f5d4c23 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -1753,7 +1753,7 @@ static int prepare_read_control_remainder(struct ceph_connection *con)
>  	return 0;
>  }
>  
> -static void prepare_read_data(struct ceph_connection *con)
> +static int prepare_read_data(struct ceph_connection *con)
>  {
>  	struct bio_vec bv;
>  
> @@ -1762,23 +1762,55 @@ static void prepare_read_data(struct ceph_connection *con)
>  				  data_len(con->in_msg));
>  
>  	get_bvec_at(&con->v2.in_cursor, &bv);
> -	set_in_bvec(con, &bv);
> +	if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
> +		if (unlikely(!con->bounce_page)) {
> +			con->bounce_page = alloc_page(GFP_NOIO);
> +			if (!con->bounce_page) {
> +				pr_err("failed to allocate bounce page\n");
> +				return -ENOMEM;
> +			}
> +		}
> +
> +		bv.bv_page = con->bounce_page;
> +		bv.bv_offset = 0;
> +		set_in_bvec(con, &bv);
> +	} else {
> +		set_in_bvec(con, &bv);
> +	}
>  	con->v2.in_state = IN_S_PREPARE_READ_DATA_CONT;
> +	return 0;
>  }
>  
>  static void prepare_read_data_cont(struct ceph_connection *con)
>  {
>  	struct bio_vec bv;
>  
> -	con->in_data_crc = ceph_crc32c_page(con->in_data_crc,
> -					    con->v2.in_bvec.bv_page,
> -					    con->v2.in_bvec.bv_offset,
> -					    con->v2.in_bvec.bv_len);
> +	if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
> +		con->in_data_crc = crc32c(con->in_data_crc,
> +					  page_address(con->bounce_page),
> +					  con->v2.in_bvec.bv_len);
> +
> +		get_bvec_at(&con->v2.in_cursor, &bv);
> +		memcpy_to_page(bv.bv_page, bv.bv_offset,
> +			       page_address(con->bounce_page),
> +			       con->v2.in_bvec.bv_len);
> +	} else {
> +		con->in_data_crc = ceph_crc32c_page(con->in_data_crc,
> +						    con->v2.in_bvec.bv_page,
> +						    con->v2.in_bvec.bv_offset,
> +						    con->v2.in_bvec.bv_len);
> +	}
>  
>  	ceph_msg_data_advance(&con->v2.in_cursor, con->v2.in_bvec.bv_len);
>  	if (con->v2.in_cursor.total_resid) {
>  		get_bvec_at(&con->v2.in_cursor, &bv);
> -		set_in_bvec(con, &bv);
> +		if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
> +			bv.bv_page = con->bounce_page;
> +			bv.bv_offset = 0;
> +			set_in_bvec(con, &bv);
> +		} else {
> +			set_in_bvec(con, &bv);
> +		}
>  		WARN_ON(con->v2.in_state != IN_S_PREPARE_READ_DATA_CONT);
>  		return;
>  	}
> @@ -1791,14 +1823,13 @@ static void prepare_read_data_cont(struct ceph_connection *con)
>  	con->v2.in_state = IN_S_HANDLE_EPILOGUE;
>  }
>  
> -static void prepare_read_tail_plain(struct ceph_connection *con)
> +static int prepare_read_tail_plain(struct ceph_connection *con)
>  {
>  	struct ceph_msg *msg = con->in_msg;
>  
>  	if (!front_len(msg) && !middle_len(msg)) {
>  		WARN_ON(!data_len(msg));
> -		prepare_read_data(con);
> -		return;
> +		return prepare_read_data(con);
>  	}
>  
>  	reset_in_kvecs(con);
> @@ -1823,6 +1854,7 @@ static void prepare_read_tail_plain(struct ceph_connection *con)
>  		add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_PLAIN_LEN);
>  		con->v2.in_state = IN_S_HANDLE_EPILOGUE;
>  	}
> +	return 0;
>  }
>  
>  static void prepare_read_enc_page(struct ceph_connection *con)
> @@ -2692,8 +2724,7 @@ static int __handle_control(struct ceph_connection *con, void *p)
>  	if (con_secure(con))
>  		return prepare_read_tail_secure(con);
>  
> -	prepare_read_tail_plain(con);
> -	return 0;
> +	return prepare_read_tail_plain(con);
>  }
>  
>  static int handle_preamble(struct ceph_connection *con)
> @@ -2849,8 +2880,7 @@ static int populate_in_iter(struct ceph_connection *con)
>  			ret = handle_control_remainder(con);
>  			break;
>  		case IN_S_PREPARE_READ_DATA:
> -			prepare_read_data(con);
> -			ret = 0;
> +			ret = prepare_read_data(con);
>  			break;
>  		case IN_S_PREPARE_READ_DATA_CONT:
>  			prepare_read_data_cont(con);

Reviewed-by: Jeff Layton <jlayton@kernel.org>

