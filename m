Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2532B304139
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Jan 2021 16:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391627AbhAZPAS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Jan 2021 10:00:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391565AbhAZO7w (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 26 Jan 2021 09:59:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2FD322D58;
        Tue, 26 Jan 2021 14:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611673151;
        bh=OE4A4yYteqnM/AjbEHJdx9htoE/QlOa9AXKKjhsNG7g=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=IcDNrE18qLWmASF8/w/Bm+rR8NS5Vk+UeJhpIUJ2pDDc8K8nMaXd8PiGdP4WWfYbT
         ROgqk0wW0vwIs+CrS7FhrYs1p10DLCzc4r3Sr5cEv/uyCTYwSkfORxqBkI1ZF14cTv
         NRiDlNXaYQcw/JydWC5ugKTy494AgloAVSKXUzfpcYwlkHiN82NF1hrGAmKqW1/YeG
         EHMVHH42r0TbLscBHbAWF05sVaHKE2ebN3JnZjrItRBWTUg+0SyfppiGV++Y1vP3mE
         1leH6DtCJaV+7uQq2P51kEttVh5OVDpojyMzx6KIdhq23XSBdiCuhfmwKfiz6tf3kf
         iiySn1s8DTVZg==
Message-ID: <81015316607f9df5cc8c3221d62be7eca9a7673c.camel@kernel.org>
Subject: Re: [PATCH] libceph: deprecate [no]cephx_require_signatures options
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Tue, 26 Jan 2021 09:59:10 -0500
In-Reply-To: <20210125173526.10103-1-idryomov@gmail.com>
References: <20210125173526.10103-1-idryomov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-01-25 at 18:35 +0100, Ilya Dryomov wrote:
> These options were introduced in 3.19 with support for message signing
> and are rather useless, as explained in commit a51983e4dd2d ("libceph:
> add nocephx_sign_messages option").  Deprecate them.
> 
> In case there is someone out there with a cluster that lacks support
> for MSG_AUTH feature (very unlikely but has to be considered since we
> haven't formally raised the bar from argonaut to bobtail yet), make
> nocephx_sign_messages also waive MSG_AUTH requirement.  This is probably
> how it should have been done in the first place -- if we aren't going
> to sign, requiring the signing feature makes no sense.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  include/linux/ceph/libceph.h |  7 +++----
>  net/ceph/ceph_common.c       | 11 +++++------
>  2 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index eb9008bb3992..409d8c29bc4f 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -32,10 +32,9 @@
>  #define CEPH_OPT_NOSHARE          (1<<1) /* don't share client with other sbs */
>  #define CEPH_OPT_MYIP             (1<<2) /* specified my ip */
>  #define CEPH_OPT_NOCRC            (1<<3) /* no data crc on writes (msgr1) */
> -#define CEPH_OPT_NOMSGAUTH	  (1<<4) /* don't require msg signing feat */
> -#define CEPH_OPT_TCP_NODELAY	  (1<<5) /* TCP_NODELAY on TCP sockets */
> -#define CEPH_OPT_NOMSGSIGN	  (1<<6) /* don't sign msgs (msgr1) */
> -#define CEPH_OPT_ABORT_ON_FULL	  (1<<7) /* abort w/ ENOSPC when full */
> +#define CEPH_OPT_TCP_NODELAY      (1<<4) /* TCP_NODELAY on TCP sockets */
> +#define CEPH_OPT_NOMSGSIGN        (1<<5) /* don't sign msgs (msgr1) */
> +#define CEPH_OPT_ABORT_ON_FULL    (1<<6) /* abort w/ ENOSPC when full */
>  
> 
>  #define CEPH_OPT_DEFAULT   (CEPH_OPT_TCP_NODELAY)
>  
> 
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index 271287c5ec12..bec181181d41 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -307,7 +307,8 @@ static const struct constant_table ceph_param_ms_mode[] = {
>  
> 
>  static const struct fs_parameter_spec ceph_parameters[] = {
>  	fsparam_flag	("abort_on_full",		Opt_abort_on_full),
> -	fsparam_flag_no ("cephx_require_signatures",	Opt_cephx_require_signatures),
> +	__fsparam	(NULL, "cephx_require_signatures", Opt_cephx_require_signatures,
> +			 fs_param_neg_with_no|fs_param_deprecated, NULL),
>  	fsparam_flag_no ("cephx_sign_messages",		Opt_cephx_sign_messages),
>  	fsparam_flag_no ("crc",				Opt_crc),
>  	fsparam_string	("crush_location",		Opt_crush_location),
> @@ -596,9 +597,9 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
>  		break;
>  	case Opt_cephx_require_signatures:
>  		if (!result.negated)
> -			opt->flags &= ~CEPH_OPT_NOMSGAUTH;
> +			warn_plog(&log, "Ignoring cephx_require_signatures");
>  		else
> -			opt->flags |= CEPH_OPT_NOMSGAUTH;
> +			warn_plog(&log, "Ignoring nocephx_require_signatures, use nocephx_sign_messages");
>  		break;
>  	case Opt_cephx_sign_messages:
>  		if (!result.negated)
> @@ -686,8 +687,6 @@ int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
>  		seq_puts(m, "noshare,");
>  	if (opt->flags & CEPH_OPT_NOCRC)
>  		seq_puts(m, "nocrc,");
> -	if (opt->flags & CEPH_OPT_NOMSGAUTH)
> -		seq_puts(m, "nocephx_require_signatures,");
>  	if (opt->flags & CEPH_OPT_NOMSGSIGN)
>  		seq_puts(m, "nocephx_sign_messages,");
>  	if ((opt->flags & CEPH_OPT_TCP_NODELAY) == 0)
> @@ -756,7 +755,7 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private)
>  	client->supported_features = CEPH_FEATURES_SUPPORTED_DEFAULT;
>  	client->required_features = CEPH_FEATURES_REQUIRED_DEFAULT;
>  
> 
> -	if (!ceph_test_opt(client, NOMSGAUTH))
> +	if (!ceph_test_opt(client, NOMSGSIGN))
>  		client->required_features |= CEPH_FEATURE_MSG_AUTH;
>  
> 
>  	/* msgr */


Reviewed-by: Jeff Layton <jlayton@kernel.org>

